import pytest
from unittest.mock import MagicMock
from lambdalib import LambalibTechLibrary
from siliconcompiler import ASIC
from siliconcompiler.library import LibrarySchema


# Mocking LibrarySchema for the techlibs list
class MockTechLib(LibrarySchema):
    def __init__(self):
        pass


class ConcreteLib(LambalibTechLibrary):
    def __init__(self):
        super().__init__("mylib", [MockTechLib])


class ConcreteLibNoTech(LambalibTechLibrary):
    def __init__(self):
        super().__init__("mylib_notech", [])


class ConcreteLibNoneTech(LambalibTechLibrary):
    def __init__(self):
        super().__init__("mylib_none", None)


def test_init_and_properties():
    lib = ConcreteLib()
    assert lib.cell == "mylib"
    assert len(lib.techlibs) == 1
    assert lib.techlibs[0] == MockTechLib

    lib_notech = ConcreteLibNoTech()
    assert lib_notech.cell == "mylib_notech"
    assert lib_notech.techlibs == []

    lib_none = ConcreteLibNoneTech()
    assert lib_none.cell == "mylib_none"
    assert lib_none.techlibs == []


def test_alias_not_asic():
    # project is not ASIC
    project = MagicMock()
    # MagicMock is not instance of ASIC unless we spec it.

    ConcreteLib.alias(project)
    # Should return immediately


def test_alias_no_library():
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = False

    ConcreteLib.alias(project)

    project._has_library.assert_called_with("mylib")
    project.add_alias.assert_not_called()


def test_alias_success():
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ConcreteLib.alias(project)

    project._has_library.assert_called_with("mylib")

    # Check add_alias
    assert project.add_alias.call_count == 1
    args = project.add_alias.call_args[0]
    assert args[0] == "mylib"
    assert args[1] == "rtl"
    assert isinstance(args[2], ConcreteLib)
    assert args[3] == "rtl"

    # Check add_asiclib
    assert project.add_asiclib.call_count == 1
    added_lib = project.add_asiclib.call_args[0][0]
    assert isinstance(added_lib, MockTechLib)
