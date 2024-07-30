from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import stdlib


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib auxlib
    '''

    lib = Library(chip, 'lambdalib_auxlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "auxlib/rtl")

    lib.use(stdlib)

    return lib
