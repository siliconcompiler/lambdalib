from typing import List

from siliconcompiler import Design, ASIC
from siliconcompiler.library import LibrarySchema

#  individual modules
from lambdalib import auxlib
from lambdalib import fpgalib
from lambdalib import iolib
from lambdalib import padring
from lambdalib import stdlib
from lambdalib import ramlib
from lambdalib import veclib

__version__ = "0.4.0-rc2"


class LambalibTechLibrary(Design):
    """A Design class to manage a lambda library and its associated technology libraries.

    This class encapsulates a main lambda library cell and a list of technology
    libraries, providing a mechanism to alias them within an ASIC project.
    """
    def __init__(self, lambdalib, techlibs: List[LibrarySchema]):
        """Initializes the LambalibTechLibrary instance.

        Args:
            lambdalib: The main lambda library cell.
            techlibs (list): A list of technology library classes to be associated
                             with the main lambda library.
        """
        super().__init__()

        self.__cell = lambdalib

        if not techlibs:
            techlibs = []
        self.__techlibs = techlibs

    @classmethod
    def alias(cls, project: ASIC) -> None:
        """Creates and registers aliases for the library and its techlibs in a project.

        This method checks if the provided project is an ASIC and if the
        lambda library cell exists within the project's libraries. If both
        conditions are met, it adds an alias for the main library and adds
        each associated technology library to the project's ASIC libraries.

        Args:
            project (ASIC): The ASIC project instance to which the aliases
                                   and libraries will be added.
        """
        if not isinstance(project, ASIC):
            return

        tech = cls()
        if not project._has_library(tech.__cell):
            return

        project.add_alias(tech.__cell, "rtl", tech, "rtl")

        for lib in tech.__techlibs:
            project.add_asiclib(lib())


__all__ = [
    "auxlib",
    "fpgalib",
    "iolib",
    "padring",
    "stdlib",
    "ramlib",
    "veclib"
]
