from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import auxlib


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib ramlib
    '''

    lib = Library(chip, 'lambdalib_ramlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "ramlib/rtl")

    lib.use(auxlib)

    return lib
