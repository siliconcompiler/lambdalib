"""Tests for the reusable techlib interface check.

The reusable machinery + the ``assert_techlib_interface`` fixture live in
:mod:`lambdalib.reusable_tests.techlib_interface`; downstream PDK suites consume
them by adding that module to ``pytest_plugins``.  These tests exercise the
extraction, diff, and fixture against real lambda cells and synthetic techlibs.

pyslang is optional; these tests skip cleanly when it is not installed.
"""
import textwrap

import pytest

pytest.importorskip("pyslang")  # noqa: E402

from lambdalib.reusable_tests.techlib_interface import (  # noqa: E402
    extract_interface,
    compare_interfaces,
    find_lambda_design,
    verilog_files,
)

# The assert_techlib_interface fixture is auto-loaded via the pytest11 entry
# point declared in pyproject.toml -- no conftest registration needed.


# ---------------------------------------------------------------------------
# Self-contained tests of the comparison machinery, independent of any real
# tech library.  These exercise the pyslang extraction + diff on synthetic RTL.
# ---------------------------------------------------------------------------

_REFERENCE_V = textwrap.dedent("""
    module la_widget #(
        parameter DW = 32,
        parameter PROP = "DEFAULT"
    ) (
        input               clk,
        input  [DW-1:0]     din,
        output [DW-1:0]     dout
    );
    endmodule
""")


def _write(tmp_path, name, text):
    path = tmp_path / name
    path.write_text(text)
    return str(path)


def test_identical_interface_matches(tmp_path):
    ref_file = _write(tmp_path, "ref.v", _REFERENCE_V)
    impl_file = _write(tmp_path, "impl.v", _REFERENCE_V)

    ref = extract_interface([ref_file], "la_widget")
    impl = extract_interface([impl_file], "la_widget")

    assert compare_interfaces(ref, impl) == []
    assert set(ref.ports) == {"clk", "din", "dout"}
    assert set(ref.params) == {"DW", "PROP"}
    assert ref.ports["clk"].direction == "in"
    assert ref.ports["dout"].direction == "out"


def test_detects_missing_and_extra_ports(tmp_path):
    impl_v = textwrap.dedent("""
        module la_widget #(
            parameter DW = 32,
            parameter PROP = "DEFAULT"
        ) (
            input               clk,
            input  [DW-1:0]     din,
            output [DW-1:0]     dout,
            output              valid   // extra port
        );
        endmodule
    """)
    ref = extract_interface([_write(tmp_path, "ref.v", _REFERENCE_V)], "la_widget")
    impl = extract_interface([_write(tmp_path, "impl.v", impl_v)], "la_widget")

    errors = compare_interfaces(ref, impl)
    assert any("valid" in e for e in errors)


def test_detects_direction_mismatch(tmp_path):
    impl_v = _REFERENCE_V.replace("output [DW-1:0]     dout", "input  [DW-1:0]     dout")
    ref = extract_interface([_write(tmp_path, "ref.v", _REFERENCE_V)], "la_widget")
    impl = extract_interface([_write(tmp_path, "impl.v", impl_v)], "la_widget")

    errors = compare_interfaces(ref, impl)
    assert any("dout" in e and "direction" in e for e in errors)


def test_detects_width_mismatch(tmp_path):
    impl_v = _REFERENCE_V.replace("parameter DW = 32", "parameter DW = 16")
    ref = extract_interface([_write(tmp_path, "ref.v", _REFERENCE_V)], "la_widget")
    impl = extract_interface([_write(tmp_path, "impl.v", impl_v)], "la_widget")

    errors = compare_interfaces(ref, impl)
    # DW default differs -> parameter mismatch; and resolved port widths differ.
    assert any("din" in e and "width" in e for e in errors) or \
        any("DW" in e for e in errors)


def test_detects_param_default_mismatch(tmp_path):
    impl_v = _REFERENCE_V.replace('parameter PROP = "DEFAULT"',
                                  'parameter PROP = "CUSTOM"')
    ref = extract_interface([_write(tmp_path, "ref.v", _REFERENCE_V)], "la_widget")
    impl = extract_interface([_write(tmp_path, "impl.v", impl_v)], "la_widget")

    assert any("PROP" in e for e in compare_interfaces(ref, impl))
    # ...and lenient mode ignores the default difference.
    assert compare_interfaces(ref, impl, check_param_defaults=False) == []


# ---------------------------------------------------------------------------
# Sanity check against a real lambda cell so the resolver + extraction are
# exercised on shipped RTL (not just synthetic modules).
# ---------------------------------------------------------------------------

def test_reference_extraction_on_real_cell():
    design = find_lambda_design("la_spram")
    assert design is not None, "la_spram cell should be discoverable"

    iface = extract_interface(verilog_files(design, "rtl"), "la_spram")
    # Interface documented in lambdalib/ramlib/la_spram/rtl/la_spram.v
    assert {"clk", "ce", "we", "wmask", "addr", "din", "dout"} <= set(iface.ports)
    assert {"DW", "AW", "PROP"} <= set(iface.params)


# ---------------------------------------------------------------------------
# End-to-end via the assert_techlib_interface fixture, against the real la_and2
# lambda cell with synthetic LambalibTechLibrary subclasses standing in for a PDK.
#
# A real LambalibTechLibrary is itself a Design that names the lambda cell it
# substitutes (.cell) and carries the tech-specific wrapper for that cell in its
# own rtl fileset -- exactly how lambdapdk's Fake*Lambdalib_* libraries are built.
# ---------------------------------------------------------------------------

def _make_techlib(tmp_path, name, verilog):
    """Build a LambalibTechLibrary whose own rtl fileset holds `verilog`."""
    from lambdalib import LambalibTechLibrary

    vpath = tmp_path / f"{name}.v"
    vpath.write_text(verilog)

    class _TechLib(LambalibTechLibrary):
        def __init__(self):
            super().__init__("la_and2", [])
            self.set_name(name)
            self.set_dataroot(name, str(tmp_path))
            with self.active_fileset("rtl"):
                self.set_topmodule("la_and2")
                with self.active_dataroot(name):
                    self.add_file(f"{name}.v")

    return _TechLib


def test_fixture_passes_matching_implementation(tmp_path, assert_techlib_interface):
    good = _make_techlib(
        tmp_path, "good_tech",
        'module la_and2 #(parameter PROP="DEFAULT")'
        '(input a, input b, output z);\nassign z=a&b;\nendmodule\n')

    # Pass the class; the fixture asserts it is a LambalibTechLibrary and checks it.
    assert_techlib_interface(good)


def test_fixture_fails_mismatched_implementation(tmp_path, assert_techlib_interface):
    bad = _make_techlib(
        tmp_path, "bad_tech",
        'module la_and2 (input a, input b, input z, output w);\nendmodule\n')

    with pytest.raises(AssertionError) as exc:
        assert_techlib_interface(bad)

    report = str(exc.value)
    assert "w" in report                       # extra port
    assert "z" in report and "direction" in report  # direction flipped
    assert "PROP" in report                     # missing parameter


def test_fixture_rejects_non_techlib(assert_techlib_interface):
    """A non-LambalibTechLibrary argument fails the assertion up front."""
    from siliconcompiler import Design

    with pytest.raises(AssertionError, match="not a LambalibTechLibrary"):
        assert_techlib_interface(Design)
