from siliconcompiler import Library
from lambdalib._common import register_data_source
import lambdalib.stdlib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib auxlib
    '''

    lib = Library('lambdalib_auxlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "auxlib/rtl")

    lib.use(lambdalib.stdlib)

    return lib
