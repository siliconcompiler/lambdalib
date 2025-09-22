from siliconcompiler import Design

from .la_vbuf.la_vbuf import Vbuf
from .la_vinv.la_vinv import Vinv
from .la_vmux.la_vmux import Vmux
from .la_vmux2b.la_vmux2b import Vmux2b
from .la_vmux2.la_vmux2 import Vmux2
from .la_vmux3.la_vmux3 import Vmux3
from .la_vmux4.la_vmux4 import Vmux4
from .la_vmux5.la_vmux5 import Vmux5
from .la_vmux6.la_vmux6 import Vmux6
from .la_vmux7.la_vmux7 import Vmux7
from .la_vmux8.la_vmux8 import Vmux8
from .la_vpriority.la_vpriority import Vpriority

__all__ = ['Vbuf',
           'Vinv',
           'Vmux',
           'Vmux2',
           'Vmux2b',
           'Vmux3',
           'Vmux4',
           'Vmux5',
           'Vmux6',
           'Vmux7',
           'Vmux8',
           'Vpriority'
           ]


class STDLib(Design):
    def __init__(self):
        super().__init__("la_veclib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Vbuf(), depfileset="rtl")
            self.add_depfileset(Vinv(), depfileset="rtl")
            self.add_depfileset(Vmux(), depfileset="rtl")
            self.add_depfileset(Vmux2(), depfileset="rtl")
            self.add_depfileset(Vmux2b(), depfileset="rtl")
            self.add_depfileset(Vmux3(), depfileset="rtl")
            self.add_depfileset(Vmux4(), depfileset="rtl")
            self.add_depfileset(Vmux5(), depfileset="rtl")
            self.add_depfileset(Vmux6(), depfileset="rtl")
            self.add_depfileset(Vmux7(), depfileset="rtl")
            self.add_depfileset(Vmux8(), depfileset="rtl")
            self.add_depfileset(Vpriority(), depfileset="rtl")
