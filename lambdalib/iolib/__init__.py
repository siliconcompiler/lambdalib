from .la_ioanalog.la_ioanalog import la_ioanalog
from .la_iobidir.la_iobidir import la_iobidir
from .la_ioclamp.la_ioclamp import la_ioclamp
from .la_iocorner.la_iocorner import la_iocorner
from .la_iocut.la_iocut import la_iocut
from .la_ioinput.la_ioinput import la_ioinput
from .la_iopoc.la_iopoc import la_iopoc
from .la_iorxdiff.la_iorxdiff import la_iorxdiff
from .la_iotxdiff.la_iotxdiff import la_iotxdiff
from .la_iovdda.la_iovdda import la_iovdda
from .la_iovddio.la_iovddio import la_iovddio
from .la_iovdd.la_iovdd import la_iovdd
from .la_iovssa.la_iovssa import la_iovssa
from .la_iovssio.la_iovssio import la_iovssio
from .la_iovss.la_iovss import la_iovss
from .la_ioxtal.la_ioxtal impoirt Ioxtal


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
             'la_ioxtal']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')

    return lib
