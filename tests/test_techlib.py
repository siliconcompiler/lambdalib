"""Comprehensive tests for lambdalib.LambalibTechLibrary module."""
import pytest
from unittest.mock import MagicMock
from lambdalib import LambalibTechLibrary
from siliconcompiler import ASIC
from siliconcompiler.library import LibrarySchema


# Concrete implementations for testing
class MockTechLib(LibrarySchema):
    """Mock technology library for testing."""
    def __init__(self):
        pass


class AnotherMockTechLib(LibrarySchema):
    """Another mock technology library for testing."""
    def __init__(self):
        pass


class ValidConcreteLib(LambalibTechLibrary):
    """Valid subclass with zero-arg constructor."""
    def __init__(self):
        super().__init__("valid_lib", [MockTechLib, AnotherMockTechLib])


class ValidConcreteLosLib(LambalibTechLibrary):
    """Valid subclass with empty techlibs."""
    def __init__(self):
        super().__init__("empty_lib", [])


class ValidConcreteNoneTechLib(LambalibTechLibrary):
    """Valid subclass with None techlibs."""
    def __init__(self):
        super().__init__("none_lib", None)


class InvalidConcreteLib(LambalibTechLibrary):
    """Invalid subclass missing zero-arg constructor."""
    def __init__(self, required_arg):
        super().__init__("invalid_lib", [MockTechLib])


# ============================================================================
# Tests for __init__
# ============================================================================

def test_init_with_valid_string_and_list():
    """Test initialization with valid string name and techlib list."""
    lib = ValidConcreteLib()
    assert lib.cell == "valid_lib"
    assert len(lib.techlibs) == 2
    assert MockTechLib in lib.techlibs
    assert AnotherMockTechLib in lib.techlibs


def test_init_with_empty_techlib_list():
    """Test initialization with empty techlib list."""
    lib = ValidConcreteLosLib()
    assert lib.cell == "empty_lib"
    assert lib.techlibs == []


def test_init_with_none_techlib():
    """Test initialization converts None techlib to empty list."""
    lib = ValidConcreteNoneTechLib()
    assert lib.cell == "none_lib"
    assert lib.techlibs == []


def test_init_accepts_non_string_lambdalib():
    """Test initialization accepts any type for lambdalib (no runtime validation)."""
    class IntLib(LambalibTechLibrary):
        def __init__(self):
            super().__init__(123, [MockTechLib])

    lib = IntLib()
    assert lib.cell == 123


def test_init_stores_cell_name():
    """Test that lambdalib parameter is stored correctly."""
    lib = ValidConcreteLib()
    assert lib.cell == "valid_lib"


# ============================================================================
# Tests for cell property
# ============================================================================

def test_cell_property_returns_string():
    """Test that cell property returns the stored cell name."""
    lib = ValidConcreteLib()
    cell_name = lib.cell
    assert isinstance(cell_name, str)
    assert cell_name == "valid_lib"


def test_cell_property_immutable():
    """Test that modifying cell doesn't affect stored value."""
    lib = ValidConcreteLib()
    original_cell = lib.cell
    # Attempting to set would raise AttributeError since it's a property
    with pytest.raises(AttributeError):
        lib.cell = "modified"
    assert lib.cell == original_cell


# ============================================================================
# Tests for techlibs property
# ============================================================================

def test_techlibs_property_returns_list():
    """Test that techlibs property returns a list."""
    lib = ValidConcreteLib()
    techlibs = lib.techlibs
    assert isinstance(techlibs, list)


def test_techlibs_property_contains_correct_classes():
    """Test that techlibs contains the expected classes."""
    lib = ValidConcreteLib()
    techlibs = lib.techlibs
    assert len(techlibs) == 2
    assert MockTechLib in techlibs
    assert AnotherMockTechLib in techlibs


def test_techlibs_property_returns_copy():
    """Test that techlibs property returns a copy, not original list."""
    lib = ValidConcreteLib()
    techlibs_list = lib.techlibs
    # Verify it's a copy by checking it's a different object
    techlibs_list_again = lib.techlibs
    assert techlibs_list is not techlibs_list_again


def test_techlibs_property_mutation_does_not_affect_internal():
    """Test that mutating returned techlibs doesn't affect internal list."""
    lib = ValidConcreteLib()
    original_length = len(lib.techlibs)

    # Get techlibs and try to mutate it
    techlibs = lib.techlibs
    techlibs.append(AnotherMockTechLib)

    # Original should be unchanged
    assert len(lib.techlibs) == original_length
    assert AnotherMockTechLib not in lib.techlibs or \
        len(lib.techlibs[lib.techlibs.index(AnotherMockTechLib):]) == 1


def test_techlibs_empty_list_returns_copy():
    """Test that empty techlibs list is returned as a copy."""
    lib = ValidConcreteLosLib()
    techlibs1 = lib.techlibs
    techlibs2 = lib.techlibs
    assert techlibs1 == []
    assert techlibs2 == []
    assert techlibs1 is not techlibs2


# ============================================================================
# Tests for alias() classmethod - basic functionality
# ============================================================================

def test_alias_with_non_asic_returns_early():
    """Test that alias() returns early if project is not an ASIC."""
    not_asic = MagicMock()
    # Should not raise, just return
    ValidConcreteLib.alias(not_asic)
    # No assertions needed, just verifying no exception


def test_alias_with_none_returns_early():
    """Test that alias() handles None project gracefully."""
    # This would fail isinstance check and return early
    ValidConcreteLib.alias(None)
    # No exception should be raised


def test_alias_with_asic_no_library():
    """Test alias() when library doesn't exist in project."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = False

    ValidConcreteLib.alias(project)

    project._has_library.assert_called_once_with("valid_lib")
    project.add_alias.assert_not_called()
    project.add_asiclib.assert_not_called()


def test_alias_with_asic_library_exists_no_techlibs():
    """Test alias() success with no technology libraries."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ValidConcreteLosLib.alias(project)

    project._has_library.assert_called_once_with("empty_lib")
    project.add_alias.assert_called_once()
    project.add_asiclib.assert_not_called()


def test_alias_calls_add_alias_with_correct_params():
    """Test that alias() calls add_alias with correct parameters."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ValidConcreteLib.alias(project)

    # Check add_alias call
    assert project.add_alias.call_count == 1
    call_args = project.add_alias.call_args[0]
    assert call_args[0] == "valid_lib"
    assert call_args[1] == "rtl"
    assert isinstance(call_args[2], ValidConcreteLib)
    assert call_args[3] == "rtl"


def test_alias_with_single_techlib():
    """Test alias() adds single technology library."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    class SingleTechLib(LambalibTechLibrary):
        def __init__(self):
            super().__init__("single", [MockTechLib])

    SingleTechLib.alias(project)

    assert project.add_asiclib.call_count == 1
    added_lib = project.add_asiclib.call_args[0][0]
    assert isinstance(added_lib, MockTechLib)


def test_alias_with_multiple_techlibs():
    """Test alias() adds multiple technology libraries."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ValidConcreteLib.alias(project)

    assert project.add_asiclib.call_count == 2
    calls = project.add_asiclib.call_args_list
    added_instances = [call[0][0] for call in calls]
    assert isinstance(added_instances[0], MockTechLib)
    assert isinstance(added_instances[1], AnotherMockTechLib)


# ============================================================================
# Tests for alias() with zero-arg constructor validation
# ============================================================================

def test_alias_raises_valueerror_on_missing_zero_arg_constructor():
    """Test that alias() raises ValueError with clear message when zero-arg constructor missing."""
    project = MagicMock(spec=ASIC)

    with pytest.raises(ValueError) as exc_info:
        InvalidConcreteLib.alias(project)

    error_msg = str(exc_info.value)
    assert "InvalidConcreteLib" in error_msg
    assert "LambalibTechLibrary" in error_msg
    assert "zero-argument constructor" in error_msg


def test_alias_valueerror_includes_class_name():
    """Test that ValueError includes the actual subclass name."""
    project = MagicMock(spec=ASIC)

    with pytest.raises(ValueError) as exc_info:
        InvalidConcreteLib.alias(project)

    assert "InvalidConcreteLib" in str(exc_info.value)


def test_alias_valueerror_exception_chaining():
    """Test that ValueError is properly chained from TypeError."""
    project = MagicMock(spec=ASIC)

    with pytest.raises(ValueError) as exc_info:
        InvalidConcreteLib.alias(project)

    # Check that the original TypeError is preserved
    assert exc_info.value.__cause__ is not None
    assert isinstance(exc_info.value.__cause__, TypeError)


# ============================================================================
# Tests for edge cases and corner cases
# ============================================================================

def test_alias_not_called_before_library_check():
    """Test that _has_library is checked before trying to call alias."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = False

    ValidConcreteLib.alias(project)

    # Should check library existence on first call
    assert project._has_library.call_count == 1


def test_cell_with_special_characters():
    """Test initialization with special characters in cell name."""
    class LibWithSpecialName(LambalibTechLibrary):
        def __init__(self):
            super().__init__("lib_with-special.chars_123", [])

    lib = LibWithSpecialName()
    assert lib.cell == "lib_with-special.chars_123"


def test_large_techlib_list():
    """Test initialization with many technology libraries."""
    class LargeLibList(LambalibTechLibrary):
        def __init__(self):
            # Create 50 unique mock classes
            libs = [type(f'MockLib{i}', (LibrarySchema,),
                         {'__init__': lambda self: None}) for i in range(50)]
            super().__init__("large", libs)

    lib = LargeLibList()
    assert len(lib.techlibs) == 50


def test_alias_classmethod_accessible_from_subclass():
    """Test that alias() is accessible as a classmethod from subclass."""
    # Should not raise
    ValidConcreteLib.alias(MagicMock())


def test_alias_with_project_that_has_library():
    """Test complete alias() flow with mocked ASIC project."""
    project = MagicMock(spec=ASIC)
    project._has_library.return_value = True

    ValidConcreteLib.alias(project)

    # Verify both add_alias and add_asiclib were called
    assert project.add_alias.called
    assert project.add_asiclib.called


def test_inheritance_from_design():
    """Test that LambalibTechLibrary inherits from Design."""
    from siliconcompiler import Design
    lib = ValidConcreteLib()
    assert isinstance(lib, Design)
