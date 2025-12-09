from siliconcompiler import Design

from .la_asyncfifo.la_asyncfifo import Asyncfifo
from .la_syncfifo.la_syncfifo import Syncfifo
from .la_dpram.la_dpram import Dpram
from .la_spram.la_spram import Spram
from .la_tdpram.la_tdpram import Tdpram

__all__ = ['Asyncfifo',
           'Syncfifo',
           'Dpram',
           'Spram',
           'Tdpram']


class RAMLib(Design):
    def __init__(self):
        super().__init__("la_ramlib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Asyncfifo(), depfileset="rtl")
            self.add_depfileset(Syncfifo(), depfileset="rtl")
            self.add_depfileset(Dpram(), depfileset="rtl")
            self.add_depfileset(Spram(), depfileset="rtl")
            self.add_depfileset(Tdpram(), depfileset="rtl")
