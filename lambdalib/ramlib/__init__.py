from typing import Dict

from siliconcompiler import Design

from .la_asyncfifo.la_asyncfifo import Asyncfifo
from .la_syncfifo.la_syncfifo import Syncfifo
from .la_spram.la_spram import Spram
from .la_spregfile.la_spregfile import Spregfile
from .la_dpram.la_dpram import Dpram
from .la_tdpram.la_tdpram import Tdpram

__all__ = ['Asyncfifo',
           'Syncfifo',
           'Dpram',
           'Spram',
           'Tdpram']


class RAMLib(Design):
    """RAM Library Design containing various RAM and FIFO modules."""
    def __init__(self):
        super().__init__("la_ramlib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Asyncfifo(), depfileset="rtl")
            self.add_depfileset(Syncfifo(), depfileset="rtl")
            self.add_depfileset(Spram(), depfileset="rtl")
            self.add_depfileset(Spregfile(), depfileset="rtl")
            self.add_depfileset(Dpram(), depfileset="rtl")
            self.add_depfileset(Tdpram(), depfileset="rtl")


class RAMTechLib:
    """Abstract base class for RAM technology libraries."""
    def get_ram_width(self) -> int:
        """Returns the width of the RAM cell.

        Returns:
            int: The width of the RAM cell.
        """
        raise NotImplementedError("Subclasses must implement get_ram_width method")

    def get_ram_depth(self) -> int:
        """Returns the depth of the RAM cell.

        Returns:
            int: The depth of the RAM cell.
        """
        raise NotImplementedError("Subclasses must implement get_ram_depth method")

    def get_ram_ports(self) -> Dict[str, str]:
        """Returns the port mapping for the RAM cell.

        Returns:
            Dict[str, str]: A dictionary mapping port names to their expressions.
        """
        raise NotImplementedError("Subclasses must implement get_ram_ports method")

    def get_ram_libcell(self) -> str:
        """Returns the name of the RAM library cell.

        Returns:
            str: The name of the RAM library cell.
        """
        raise NotImplementedError("Subclasses must implement get_ram_libcell method")
