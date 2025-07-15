from .la_asyncfifo.la_asyncfifo import Asyncfifo
from .la_syncfifo.la_syncfifo import Syncfifo
from .la_dpram.la_dpram import Dpram
from .la_spram.la_spram import Spram

__all__ = ['Asyncfifo',
           'Syncfifo',
           'Dpram',
           'Spram']

########################################
# Old SiliconCompiler Setup (deprecated)
########################################
from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import auxlib
def setup():
    '''
    Lambdalib ramlib
    '''

    lib = Library('lambdalib_ramlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.use(auxlib)

    cells = ['la_asyncfifo',
             'la_syncfifo',
             'la_dpram',
             'la_spram']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')


    return lib
