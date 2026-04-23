from typing import List, Type

from siliconcompiler import Design, ASIC
from siliconcompiler.library import LibrarySchema

#  individual modules
from lambdalib import analoglib
from lambdalib import auxlib
from lambdalib import fpgalib
from lambdalib import iolib
from lambdalib import padring
from lambdalib import stdlib
from lambdalib import ramlib
from lambdalib import veclib

__version__ = "0.12.0"


class LambalibTechLibrary(Design):
    """A Design class to manage a lambda library and its associated technology libraries.

    This class encapsulates a main lambda library cell and a list of technology
    libraries, providing a mechanism to alias them within an ASIC project.
    """
    def __init__(self, lambdalib: str,
                 techlibs: List[Type[LibrarySchema]],
                 fileset: str = "rtl") -> None:
        """Initializes the LambalibTechLibrary instance.

        Args:
            lambdalib: The main lambda library cell.
            techlibs (list): A list of technology library classes to be associated
                             with the main lambda library.
            fileset: The fileset to use for the alias. Default is "rtl".
        """
        super().__init__()

        self.__cell: str = lambdalib
        self.__fileset: str = fileset

        if not techlibs:
            techlibs = []
        self.__techlibs: List[Type[LibrarySchema]] = techlibs.copy()

    @property
    def cell(self) -> str:
        """Returns the main lambda library cell."""
        return self.__cell

    @property
    def techlibs(self) -> List[Type[LibrarySchema]]:
        """Returns a copy of the list of associated technology libraries."""
        return self.__techlibs.copy()

    @classmethod
    def alias(cls, project: ASIC, check_filesets: bool = False) -> None:
        """Creates and registers aliases for the library and its techlibs in a project.

        Requires that subclasses of LambalibTechLibrary provide a zero-argument
        constructor for use by this classmethod.

        This method checks if the provided project is an ASIC and if the
        lambda library cell exists within the project's libraries. If both
        conditions are met, it adds an alias for the main library and adds
        each associated technology library to the project's ASIC libraries.

        Args:
            project (ASIC): The ASIC project instance to which the aliases
                and libraries will be added.
            check_filesets (bool): If True, checks for the use of the filesets
                in the project before adding the alias. This can help avoid adding
                aliases for libraries that are not actually being used in the
                project, potentially improving performance and reducing clutter
                in the project's library management. Default is False.

        Returns:
            None

        Raises:
            ValueError: If the subclass does not provide a zero-argument constructor.
        """
        if not isinstance(project, ASIC):
            return

        try:
            tech = cls()
        except TypeError as e:
            raise ValueError(
                f"Subclass '{cls.__name__}' of LambalibTechLibrary must provide a "
                f"zero-argument constructor for use in alias(). {str(e)}"
            ) from e

        if not project._has_library(tech.__cell):
            return

        if check_filesets and not any([
                tech.__cell == lib.name for lib, _ in project.get_filesets()]):
            return

        project.add_alias(tech.__cell, "rtl", tech, tech.__fileset)

        for lib in tech.__techlibs:
            project.add_asiclib(lib())


__all__ = [
    "analoglib",
    "auxlib",
    "fpgalib",
    "iolib",
    "padring",
    "stdlib",
    "ramlib",
    "veclib"
]
