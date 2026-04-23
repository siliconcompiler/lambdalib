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


class ConcreteLibCustomFileset(LambalibTechLibrary):
    def __init__(self):
        super().__init__("mylib_custom", [MockTechLib], fileset="behavioral")


class ConcreteLibSynthFileset(LambalibTechLibrary):
    def __init__(self):
        super().__init__("mylib_synth", [MockTechLib], fileset="synth")


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


def test_check_filesets_false_default():
    """Test that check_filesets=False (default) adds alias regardless of filesets."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    # Mock get_filesets to return filesets containing the library
    mock_lib = MagicMock()
    mock_lib.name = "mylib"
    project.get_filesets.return_value = [(mock_lib, "some_fileset")]

    ConcreteLib.alias(project, check_filesets=False)

    # Should still add alias even though library is in filesets
    assert project.add_alias.call_count == 1
    assert project.add_asiclib.call_count == 1
    project.get_filesets.assert_not_called()


def test_check_filesets_true_library_in_filesets():
    """Test that check_filesets=True adds alias if library is in filesets."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    # Mock get_filesets to return filesets containing the library
    mock_lib = MagicMock()
    mock_lib.name = "mylib"
    project.get_filesets.return_value = [(mock_lib, "some_fileset")]

    ConcreteLib.alias(project, check_filesets=True)

    # Should add alias because library IS in filesets
    assert project.add_alias.call_count == 1
    assert project.add_asiclib.call_count == 1
    project.get_filesets.assert_called_once()


def test_check_filesets_true_library_not_in_filesets():
    """Test that check_filesets=True skips alias if library is not in filesets."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    # Mock get_filesets to return filesets NOT containing the library
    mock_lib = MagicMock()
    mock_lib.name = "other_lib"
    project.get_filesets.return_value = [(mock_lib, "some_fileset")]

    ConcreteLib.alias(project, check_filesets=True)

    # Should NOT add alias because library is NOT in filesets
    project.add_alias.assert_not_called()
    project.add_asiclib.assert_not_called()
    project.get_filesets.assert_called_once()


def test_check_filesets_true_empty_filesets():
    """Test that check_filesets=True skips alias when filesets are empty."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    # Mock get_filesets to return empty filesets
    project.get_filesets.return_value = []

    ConcreteLib.alias(project, check_filesets=True)

    # Should NOT add alias because filesets are empty (library not in any fileset)
    project.add_alias.assert_not_called()
    project.add_asiclib.assert_not_called()
    project.get_filesets.assert_called_once()


def test_check_filesets_true_multiple_filesets():
    """Test check_filesets=True with multiple filesets, library found in one."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    # Mock get_filesets to return multiple filesets with library in the middle
    mock_lib1 = MagicMock()
    mock_lib1.name = "other_lib1"
    mock_lib2 = MagicMock()
    mock_lib2.name = "mylib"
    mock_lib3 = MagicMock()
    mock_lib3.name = "other_lib2"
    project.get_filesets.return_value = [
        (mock_lib1, "fileset1"),
        (mock_lib2, "fileset2"),
        (mock_lib3, "fileset3"),
    ]

    ConcreteLib.alias(project, check_filesets=True)

    # Should add alias because library IS found in one of the filesets
    assert project.add_alias.call_count == 1
    assert project.add_asiclib.call_count == 1


def test_fileset_default():
    """Test that default fileset is 'rtl'."""
    lib = ConcreteLib()
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    lib.alias(project)

    # Verify that add_alias is called with "rtl" as the fileset (4th argument)
    assert project.add_alias.call_count == 1
    args = project.add_alias.call_args[0]
    assert args[3] == "rtl"


def test_fileset_custom():
    """Test that custom fileset is used when specified."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ConcreteLibCustomFileset.alias(project)

    # Verify that add_alias is called with "behavioral" as the fileset
    assert project.add_alias.call_count == 1
    args = project.add_alias.call_args[0]
    assert args[3] == "behavioral"


def test_fileset_synth():
    """Test that fileset can be set to 'synth'."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ConcreteLibSynthFileset.alias(project)

    # Verify that add_alias is called with "synth" as the fileset
    assert project.add_alias.call_count == 1
    args = project.add_alias.call_args[0]
    assert args[3] == "synth"


def test_fileset_with_check_filesets_disabled():
    """Test that custom fileset is used even when check_filesets is False."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    project.get_filesets.return_value = []

    ConcreteLibCustomFileset.alias(project, check_filesets=False)

    # Should use custom fileset regardless of check_filesets parameter
    assert project.add_alias.call_count == 1
    args = project.add_alias.call_args[0]
    assert args[3] == "behavioral"


def test_fileset_with_check_filesets_enabled():
    """Test that custom fileset is used when check_filesets is True and library is in filesets."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    mock_lib = MagicMock()
    mock_lib.name = "mylib_custom"
    project.get_filesets.return_value = [(mock_lib, "some_fileset")]

    ConcreteLibCustomFileset.alias(project, check_filesets=True)

    # Should use custom fileset when alias is added (library IS in filesets)
    assert project.add_alias.call_count == 1
    args = project.add_alias.call_args[0]
    assert args[3] == "behavioral"


def test_fileset_with_check_filesets_enabled_not_in_filesets():
    """Test that custom fileset is NOT used when check_filesets is True and
    library is not in filesets."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True
    mock_lib = MagicMock()
    mock_lib.name = "other_lib"
    project.get_filesets.return_value = [(mock_lib, "some_fileset")]

    ConcreteLibCustomFileset.alias(project, check_filesets=True)

    # Should NOT add alias because library is NOT in filesets
    project.add_alias.assert_not_called()
    project.add_asiclib.assert_not_called()


def test_fileset_property_not_exposed():
    """Test that fileset is properly stored internally."""
    lib = ConcreteLibCustomFileset()
    assert lib.cell == "mylib_custom"
    # Fileset should not be exposed as a public property
    assert not hasattr(lib, 'fileset') or lib.fileset is None
