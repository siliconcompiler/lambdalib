from siliconcompiler import DesignSchema

from .la_lut4.la_lut4 import Lut4
from .la_ble4p0.la_ble4p0 import Ble4p0
from .la_clb4p0.la_clb4p0 import Clb4p0

__all__ = ['Ble4p0',
           'Clb4p0',
           'Lut4']


class FPGALib(DesignSchema):
    def __init__(self):
        super().__init__("la_fpgalib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Lut4(), depfileset="rtl")
            self.add_depfileset(Ble4p0(), depfileset="rtl")
            self.add_depfileset(Clb4p0(), depfileset="rtl")
