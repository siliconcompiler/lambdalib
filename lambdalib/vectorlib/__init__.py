from .la_vbuf.la_vbuf import vbuf
from .la_vinv.la_vinv import vinv
from .la_visohi.la_visohi import visohi
from .la_visolo.la_visolo import visolo
from .la_vmux.la_vmux import vmux
from .la_vmux2.la_vmux2 import vmux2
from .la_vmux3.la_vmux3 import vmux3
from .la_vmux4.la_vmux4 import vmux4
from .la_vmux5.la_vmux5 import vmux5
from .la_vmux6.la_vmux6 import vmux6
from .la_vmux7.la_vmux7 import vmux7
from .la_vmux8.la_vmux8 import vmux8

__all__ = ['vbuf',
           'vinv',
           'visohi',
           'visolo',
           'vmux',
           'vmux2',
           'vmux3',
           'vmux4',
           'vmux5',
           'vmux6',
           'vmux7',
           'vmux8']

########################################
# Old SiliconCompiler Setup (deprecated)
########################################
from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import stdlib
def setup():
    '''
    Lambdalib vectorlib
    '''

    lib = Library('lambdalib_vectorlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.use(stdlib)

    cells = ['la_vbuf',
             'la_vinv',
             'la_visohi',
             'la_visolo',
             'la_vmux',
             'la_vmux2',
             'la_vmux3',
             'la_vmux4',
             'la_vmux5',
             'la_vmux6',
             'la_vmux7',
             'la_vmux8']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')

    return lib
