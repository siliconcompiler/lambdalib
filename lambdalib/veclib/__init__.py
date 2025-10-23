from siliconcompiler import Design

from .la_vbuf.la_vbuf import Vbuf
from .la_vdffnq.la_vdffnq import Vdffnq
from .la_vdffq.la_vdffq import Vdffq
from .la_vinv.la_vinv import Vinv
from .la_vlatnq.la_vlatnq import Vlatnq
from .la_vlatq.la_vlatq import Vlatq
from .la_vmux.la_vmux import Vmux
from .la_vmux2b.la_vmux2b import Vmux2b
from .la_vmux2.la_vmux2 import Vmux2
from .la_vmux3.la_vmux3 import Vmux3
from .la_vmux4.la_vmux4 import Vmux4
from .la_vmux5.la_vmux5 import Vmux5
from .la_vmux6.la_vmux6 import Vmux6
from .la_vmux7.la_vmux7 import Vmux7
from .la_vmux8.la_vmux8 import Vmux8

__all__ = ['Vbuf',
           'Vdffnq',
           'Vdffq',
           'Vinv',
           'Vlatnq',
           'Vlatq',
           'Vmux',
           'Vmux2',
           'Vmux2b',
           'Vmux3',
           'Vmux4',
           'Vmux5',
           'Vmux6',
           'Vmux7',
           'Vmux8',
           ]


class STDLib(Design):
    def __init__(self):
        super().__init__("la_veclib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Vbuf(), depfileset="rtl")
            self.add_depfileset(Vdffnq(), depfileset="rtl")
            self.add_depfileset(Vdffq(), depfileset="rtl")
            self.add_depfileset(Vinv(), depfileset="rtl")
            self.add_depfileset(Vlatnq(), depfileset="rtl")
            self.add_depfileset(Vlatq(), depfileset="rtl")
            self.add_depfileset(Vmux(), depfileset="rtl")
            self.add_depfileset(Vmux2(), depfileset="rtl")
            self.add_depfileset(Vmux2b(), depfileset="rtl")
            self.add_depfileset(Vmux3(), depfileset="rtl")
            self.add_depfileset(Vmux4(), depfileset="rtl")
            self.add_depfileset(Vmux5(), depfileset="rtl")
            self.add_depfileset(Vmux6(), depfileset="rtl")
            self.add_depfileset(Vmux7(), depfileset="rtl")
            self.add_depfileset(Vmux8(), depfileset="rtl")
