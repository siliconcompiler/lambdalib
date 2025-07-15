from .la_ioanalog.la_ioanalog import ioanalog
from .la_iobidir.la_iobidir import iobidir
from .la_ioclamp.la_ioclamp import ioclamp
from .la_iocorner.la_iocorner import iocorner
from .la_iocut.la_iocut import iocut
from .la_ioinput.la_ioinput import ioinput
from .la_iopoc.la_iopoc import iopoc
from .la_iorxdiff.la_iorxdiff import iorxdiff
from .la_iotxdiff.la_iotxdiff import iotxdiff
from .la_iovdda.la_iovdda import iovdda
from .la_iovddio.la_iovddio import iovddio
from .la_iovdd.la_iovdd import iovdd
from .la_iovssa.la_iovssa import iovssa
from .la_iovssio.la_iovssio import iovssio
from .la_iovss.la_iovss import iovss
from .la_ioxtal.la_ioxtal import ioxtal
from .la_ioside.la_ioside import ioside
from .la_iopadring.la_iopadring import iopadring

__all__ = ['ioanalog',
           'iobidir',
           'ioclamp',
           'iocorner',
           'iocut',
           'ioinput',
           'iopoc',
           'iorxdiff',
           'iotxdiff',
           'iovdda',
           'iovddio',
           'iovdd',
           'iovssa',
           'iovssio',
           'iovss',
           'ioxtal',
           'ioside',
           'iopadring']

########################################
# Old SiliconCompiler Setup (deprecated)
########################################

from siliconcompiler import Library
from lambdalib._common import register_data_source


def setup():
    '''
    Lambdalib iolib
    '''

    lib = Library('lambdalib_iolib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    cells = ['la_ioanalog',
             'la_iobidir',
             'la_ioclamp',
             'la_iocorner',
             'la_iocut',
             'la_ioinput',
             'la_iopoc',
             'la_iorxdiff',
             'la_iotxdiff',
             'la_iovdda',
             'la_iovddio',
             'la_iovdd',
             'la_iovssa',
             'la_iovssio',
             'la_iovss',
             'la_ioxtal',
             'la_ioside',
             'la_iopadring']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')

    return lib
