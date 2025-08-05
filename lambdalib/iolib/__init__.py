from siliconcompiler import DesignSchema

from .la_ioanalog.la_ioanalog import Ioanalog
from .la_iobidir.la_iobidir import Iobidir
from .la_ioclamp.la_ioclamp import Ioclamp
from .la_iocorner.la_iocorner import Iocorner
from .la_iocut.la_iocut import Iocut
from .la_ioinput.la_ioinput import Ioinput
from .la_iopoc.la_iopoc import Iopoc
from .la_iorxdiff.la_iorxdiff import Iorxdiff
from .la_iotxdiff.la_iotxdiff import Iotxdiff
from .la_iovdda.la_iovdda import Iovdda
from .la_iovddio.la_iovddio import Iovddio
from .la_iovdd.la_iovdd import Iovdd
from .la_iovssa.la_iovssa import Iovssa
from .la_iovssio.la_iovssio import Iovssio
from .la_iovss.la_iovss import Iovss
from .la_ioxtal.la_ioxtal import Ioxtal

__all__ = ['Ioanalog',
           'Iobidir',
           'Ioclamp',
           'Iocorner',
           'Iocut',
           'Ioinput',
           'Iopoc',
           'Iorxdiff',
           'Iotxdiff',
           'Iovdda',
           'Iovddio',
           'Iovdd',
           'Iovssa',
           'Iovssio',
           'Iovss',
           'Ioxtal']


class IOLib(DesignSchema):
    def __init__(self):
        super().__init__("la_iolib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Iobidir(), depfileset="rtl")
            self.add_depfileset(Ioinput(), depfileset="rtl")
            self.add_depfileset(Ioanalog(), depfileset="rtl")
            self.add_depfileset(Ioxtal(), depfileset="rtl")
            self.add_depfileset(Iorxdiff(), depfileset="rtl")
            self.add_depfileset(Iotxdiff(), depfileset="rtl")
            self.add_depfileset(Iopoc(), depfileset="rtl")
            self.add_depfileset(Iocut(), depfileset="rtl")
            self.add_depfileset(Iovddio(), depfileset="rtl")
            self.add_depfileset(Iovssio(), depfileset="rtl")
            self.add_depfileset(Iovdd(), depfileset="rtl")
            self.add_depfileset(Iovss(), depfileset="rtl")
            self.add_depfileset(Iovdda(), depfileset="rtl")
            self.add_depfileset(Iovssa(), depfileset="rtl")
            self.add_depfileset(Ioclamp(), depfileset="rtl")
