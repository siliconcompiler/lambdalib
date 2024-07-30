from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import stdlib


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib vectorlib
    '''

    lib = Library(chip, 'lambdalib_vectorlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "vectorlib/rtl")

    lib.use(stdlib)

    return lib
