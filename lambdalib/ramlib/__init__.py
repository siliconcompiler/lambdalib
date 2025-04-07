from siliconcompiler import Library
from lambdalib._common import register_data_source
import lambdalib.auxlib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib ramlib
    '''

    lib = Library('lambdalib_ramlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "ramlib/rtl")

    lib.use(lambdalib.auxlib)

    return lib
