from .la_ble4p0.la_ble4p0 import ble4p0
from .la_clb4p0.la_clb4p0 import clb4p0
from .la_lut4.la_lut4 import lut4

__all__ = ['ble4p0',
           'clb4p0',
           'lut4']

########################################
# Old SiliconCompiler Setup (deprecated)
########################################
from siliconcompiler import Library
from lambdalib._common import register_data_source
def setup():
    '''
    Lambdalib fpgalib
    '''

    lib = Library('lambdalib_fpgalib', package='lambdalib', auto_enable=True)
    register_data_source(lib)


    cells = ['la_ble4p0',
             'la_clb4p0',
             'la_lut4']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')

    return lib
