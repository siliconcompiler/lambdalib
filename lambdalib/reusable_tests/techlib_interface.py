"""Reusable interface check between a lambda cell and its tech implementation.

A :class:`~lambdalib.LambalibTechLibrary` is itself a ``Design`` that names the
lambda cell it substitutes (``.cell``, e.g. ``la_spram``) and carries the
technology-specific wrapper for that cell in its own ``rtl`` fileset.  For the
alias substitution to be valid, that wrapper must present the *same* interface --
port list and parameters -- as the canonical lambdalib cell of the same name.
This module parses both with `slang <https://sv-lang.com>`_ (via the ``pyslang``
binding), elaborates them, and diffs the resulting ports and parameters.

Usage from a downstream (e.g. PDK) test suite -- ``lambdalib`` ships this module
as a ``pytest11`` plugin, so the ``assert_lambdalib_techlib_interface`` fixture is available
automatically once lambdalib is installed (no conftest changes needed)::

    import pytest
    from my_pdk import MyRamLambdalib

    @pytest.mark.parametrize("techlib", [MyRamLambdalib])
    def test_interface(techlib, assert_lambdalib_techlib_interface):
        assert_lambdalib_techlib_interface(techlib)

Or call :func:`check_techlib` directly and inspect the returned list of mismatch
messages.

``pyslang`` is an optional dependency imported lazily, so importing this module
never fails.  Install it with ``pip install lambdalib[slang]``.
"""

import functools

from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

import pytest

import lambdalib as ll


# ---------------------------------------------------------------------------
# Interface representation
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Port:
    name: str
    direction: str  # "in" | "out" | "inout"
    width: str      # canonical, elaborated type string e.g. "logic[31:0]"
    # Width re-resolved with each boolean-like parameter flipped, as
    # ((param-assignment, width), ...).  Captures parameter-dependent widths
    # (e.g. a byte-mask flag narrowing a mask port) that match at the defaults.
    width_by_params: Tuple[Tuple[str, str], ...] = ()


@dataclass(frozen=True)
class Param:
    name: str
    value: str      # elaborated default value, as a string


@dataclass
class Interface:
    top: str
    ports: Dict[str, Port]
    params: Dict[str, Param]


# ---------------------------------------------------------------------------
# Resolving a lambda cell name -> its reference lambdalib Design
# ---------------------------------------------------------------------------

@functools.lru_cache(maxsize=None)
def find_lambda_design(cell: str):
    """Return the reference lambdalib ``Design`` whose top module is ``cell``.

    Discovers the sub-libraries dynamically from ``lambdalib.__all__`` (rather
    than a hardcoded list) and matches each exported cell on its design name.
    Returns ``None`` if no cell matches.  Results are cached per cell name so
    repeated lookups don't rebuild every exported design.
    """
    for libname in getattr(ll, "__all__", []):
        module = getattr(ll, libname, None)
        for cls_name in getattr(module, "__all__", []):
            cls = getattr(module, cls_name, None)
            if cls is None:
                continue
            try:
                design = cls()
            except TypeError:
                # Constructor needs arguments -- not a zero-arg cell class
                # (e.g. a helper).  Real constructor bugs are left to surface.
                continue
            if getattr(design, "name", None) == cell:
                return design
    return None


# ---------------------------------------------------------------------------
# Collecting Verilog sources from a Design / LibrarySchema
# ---------------------------------------------------------------------------

_VERILOG_EXTS = (".v", ".sv", ".vh", ".svh")
_CANDIDATE_FILESETS = ("rtl", "behavioral", "synth", "default")


def verilog_files(design, fileset: Optional[str] = None) -> List[str]:
    """Return the Verilog source paths for ``design``.

    If ``fileset`` is given, only that fileset is queried.  Otherwise every
    candidate fileset present on the design is collected -- useful for techlibs
    whose fileset naming we don't know up front.
    """
    filesets = [fileset] if fileset else _CANDIDATE_FILESETS

    files: List[str] = []
    for fs in filesets:
        if not design.has_fileset(fs):
            continue
        for f in design.get_file(fileset=fs):
            if str(f).lower().endswith(_VERILOG_EXTS) and str(f) not in files:
                files.append(str(f))
    return files


# ---------------------------------------------------------------------------
# pyslang extraction
# ---------------------------------------------------------------------------

def _elaborate_interface(files: List[str], top: str,
                         param_overrides: Optional[Dict[str, object]] = None) -> Interface:
    """Elaborate ``top`` once and return its single-point interface.

    All files are added to a single compilation so that submodules resolve and
    port widths / parameter defaults are elaborated.  ``param_overrides`` maps
    parameter names to values applied to ``top`` before elaboration.  ``top`` is
    located among the compilation's top-level instances, so it must not be
    instantiated by another file in the same set.
    """
    import pyslang
    from pyslang import ast
    from pyslang.syntax import SyntaxTree

    if not files:
        raise ValueError(f"no Verilog sources found for module '{top}'")

    options = ast.CompilationOptions()
    options.topModules = {top}
    if param_overrides:
        options.paramOverrides = [f"{name}={value}"
                                  for name, value in param_overrides.items()]
    bag = pyslang.Bag()
    bag.compilationOptions = options
    compilation = ast.Compilation(bag)
    for path in files:
        compilation.addSyntaxTree(SyntaxTree.fromFile(str(path)))

    # Force elaboration so types/parameters resolve.
    compilation.getAllDiagnostics()

    root = compilation.getRoot()
    instance = next((i for i in root.topInstances if i.name == top), None)
    if instance is None:
        found = ", ".join(i.name for i in root.topInstances) or "<none>"
        raise LookupError(
            f"module '{top}' is not an elaborated top instance "
            f"(tops found: {found}). Ensure it is not instantiated by another "
            f"file in the same fileset."
        )

    ports: Dict[str, Port] = {}
    params: Dict[str, Param] = {}

    # InstanceBodySymbol is a scope; iterating it yields its members.
    for member in instance.body:
        if isinstance(member, ast.PortSymbol):
            # ArgumentDirection.{In,Out,InOut} -> "in"/"out"/"inout"
            ports[member.name] = Port(
                name=member.name,
                direction=member.direction.name.lower(),
                width=str(member.type),
            )
        elif isinstance(member, ast.ParameterSymbol):
            # Skip localparams -- they aren't part of the overridable interface.
            if getattr(member, "isLocalParam", False):
                continue
            params[member.name] = Param(name=member.name, value=str(member.value))

    return Interface(top=top, ports=ports, params=params)


def _flag_sweep(params: Dict[str, Param]) -> List[Tuple[str, Dict[str, int]]]:
    """Return ``(label, overrides)`` sample points flipping each 0/1 parameter.

    A port width gated behind a boolean-like parameter (e.g. a byte-mask mode
    that narrows the write-mask port) matches while both sides sit at the default
    value and only diverges once the flag is toggled, so each flip is a sample
    point at which such widths are re-resolved.
    """
    sweeps: List[Tuple[str, Dict[str, int]]] = []
    for name in sorted(params):
        try:
            value = int(params[name].value)
        except (TypeError, ValueError):
            continue  # non-integer (e.g. string) parameter
        if value in (0, 1):
            flipped = 1 - value
            sweeps.append((f"{name}={flipped}", {name: flipped}))
    return sweeps


def extract_interface(files: List[str], top: str) -> Interface:
    """Parse ``files`` with pyslang and return the interface of module ``top``.

    Port widths are resolved at the default parameters *and* re-resolved with each
    boolean-like parameter flipped, recording the latter in ``Port.width_by_params``.
    This means a width that depends on a parameter (e.g. a byte-mask flag narrowing
    a write-mask port) is captured in the interface rather than hiding behind its
    default value -- and :func:`compare_interfaces` diffs the full profile, so the
    protection applies to every comparison automatically.
    """
    base = _elaborate_interface(files, top)

    sweeps = _flag_sweep(base.params)
    if not sweeps:
        return base

    profiles: Dict[str, List[Tuple[str, str]]] = {name: [] for name in base.ports}
    for label, overrides in sweeps:
        alt = _elaborate_interface(files, top, overrides)
        for name in base.ports:
            if name in alt.ports:
                profiles[name].append((label, alt.ports[name].width))

    ports = {
        name: Port(port.name, port.direction, port.width, tuple(profiles[name]))
        for name, port in base.ports.items()
    }
    return Interface(top=base.top, ports=ports, params=base.params)


# ---------------------------------------------------------------------------
# Comparison
# ---------------------------------------------------------------------------

def compare_interfaces(ref: Interface, impl: Interface,
                       check_param_defaults: bool = True) -> List[str]:
    """Return a list of human-readable mismatch messages (empty == exact match).

    Exact match: identical port names, directions and widths, and identical
    parameter names (and defaults, unless ``check_param_defaults`` is False).
    """
    errors: List[str] = []

    ref_ports, impl_ports = set(ref.ports), set(impl.ports)
    for name in sorted(ref_ports - impl_ports):
        errors.append(f"port '{name}' is missing from the tech implementation")
    for name in sorted(impl_ports - ref_ports):
        errors.append(f"port '{name}' is present in the tech implementation but "
                      f"not in the lambda cell")
    for name in sorted(ref_ports & impl_ports):
        rp, ip = ref.ports[name], impl.ports[name]
        if rp.direction != ip.direction:
            errors.append(f"port '{name}' direction mismatch: "
                          f"lambda={rp.direction} tech={ip.direction}")
        # Width at the defaults ("") plus every parameter sample both sides
        # share.  Divergent parameter sets are reported by the parameter checks.
        rprof = {"": rp.width, **dict(rp.width_by_params)}
        iprof = {"": ip.width, **dict(ip.width_by_params)}
        for label in ["", *sorted((set(rprof) & set(iprof)) - {""})]:
            if rprof[label] != iprof[label]:
                where = f" (at {label})" if label else ""
                errors.append(f"port '{name}' width mismatch{where}: "
                              f"lambda={rprof[label]} tech={iprof[label]}")
                break

    ref_params, impl_params = set(ref.params), set(impl.params)
    for name in sorted(ref_params - impl_params):
        errors.append(f"parameter '{name}' is missing from the tech implementation")
    for name in sorted(impl_params - ref_params):
        errors.append(f"parameter '{name}' is present in the tech implementation "
                      f"but not in the lambda cell")
    if check_param_defaults:
        for name in sorted(ref_params & impl_params):
            rp, ip = ref.params[name], impl.params[name]
            if rp.value != ip.value:
                errors.append(f"parameter '{name}' default mismatch: "
                              f"lambda={rp.value} tech={ip.value}")

    return errors


# ---------------------------------------------------------------------------
# Top-level entry point
# ---------------------------------------------------------------------------

def compare_cell_to_files(cell: str, impl_files: List[str],
                          fileset: str = "rtl",
                          check_param_defaults: bool = True) -> List[str]:
    """Compare a lambda cell's interface against an implementation given as files.

    Useful when the implementation isn't a full library -- e.g. a wrapper the
    memory templates generate via ``write_lambdalib``.  Parameter-dependent port
    widths are handled by :func:`extract_interface`, which samples them across the
    flag space, so this is a plain interface diff.

    Args:
        cell: the lambda cell name (also the top module name in ``impl_files``).
        impl_files: Verilog sources of the implementation of ``cell``.
        fileset: the lambda cell fileset that defines the reference interface.
        check_param_defaults: also require matching parameter default values.

    Returns:
        A list of mismatch messages; empty means an exact interface match.

    Raises:
        LookupError: if the lambda cell named ``cell`` cannot be found.
    """
    ref_design = find_lambda_design(cell)
    if ref_design is None:
        raise LookupError(f"no lambdalib cell named '{cell}' found")

    reference = extract_interface(verilog_files(ref_design, fileset), cell)
    impl = extract_interface(impl_files, cell)
    return compare_interfaces(reference, impl,
                              check_param_defaults=check_param_defaults)


def _as_techlib_instance(techlib):
    """Validate and normalize ``techlib`` to a ``LambalibTechLibrary`` instance.

    A class is instantiated via its zero-argument constructor.  Raises
    ``AssertionError`` if it is not a ``LambalibTechLibrary``.
    """
    if isinstance(techlib, type):
        assert issubclass(techlib, ll.LambalibTechLibrary), (
            f"{techlib.__name__} is not a LambalibTechLibrary")
        return techlib()
    assert isinstance(techlib, ll.LambalibTechLibrary), (
        f"{type(techlib).__name__} is not a LambalibTechLibrary")
    return techlib


def check_techlib(techlib, fileset: str = "rtl",
                  check_param_defaults: bool = True) -> List[str]:
    """Compare a ``LambalibTechLibrary``'s cell wrapper against its lambda cell.

    A ``LambalibTechLibrary`` is itself a ``Design``: it names the lambda cell it
    substitutes (``.cell``) and carries the technology-specific wrapper for that
    cell in its own ``fileset``.  This extracts that wrapper's interface and diffs
    it against the canonical lambdalib cell of the same name.

    Args:
        techlib: a ``LambalibTechLibrary`` subclass or instance.  A class is
            instantiated via its zero-argument constructor.
        fileset: the fileset holding the tech wrapper (and the reference cell).
        check_param_defaults: also require matching parameter default values.

    Returns:
        A list of mismatch messages; empty means an exact interface match.

    Raises:
        AssertionError: if ``techlib`` is not a ``LambalibTechLibrary``.
        LookupError: if the reference lambdalib cell cannot be found.
    """
    techlib = _as_techlib_instance(techlib)
    return compare_cell_to_files(
        techlib.cell, verilog_files(techlib, fileset),
        fileset=fileset, check_param_defaults=check_param_defaults)


def format_problems(cell: str, problems: List[str]) -> str:
    """Render a :func:`check_techlib` result as a readable multi-line string."""
    return f"{cell} interface drift:\n  " + "\n  ".join(problems)


# ---------------------------------------------------------------------------
# pytest fixture (this module doubles as a pytest plugin)
# ---------------------------------------------------------------------------

@pytest.fixture
def assert_lambdalib_techlib_interface():
    """Fixture returning an assertion helper for ``LambalibTechLibrary`` interfaces.

    The returned callable asserts its argument is a ``LambalibTechLibrary``, then
    runs :func:`check_techlib` and fails the test with a readable report if the
    tech wrapper deviates from its lambda cell interface.  Skips the test if
    ``pyslang`` is not installed.

    Example::

        def test_my_ram(assert_lambdalib_techlib_interface):
            assert_lambdalib_techlib_interface(MyRamTechLib)
    """
    pytest.importorskip("pyslang")

    def _assert(techlib, *, fileset: str = "rtl", check_param_defaults: bool = True):
        # Instantiate once and reuse the same object for the check and the report.
        techlib = _as_techlib_instance(techlib)
        problems = check_techlib(techlib, fileset=fileset,
                                 check_param_defaults=check_param_defaults)
        assert not problems, format_problems(techlib.cell, problems)

    return _assert
