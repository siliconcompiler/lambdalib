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
from .la_ioside.la_ioside import Ioside
from .la_iopadring.la_iopadring import Iopadring

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
           'Ioxtal',
           'Ioside',
           'Iopadring']

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
