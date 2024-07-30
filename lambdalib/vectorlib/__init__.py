from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib vectorlib
    '''

    lib = Library(chip, 'lambdalib_vectorlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "lambdalib/vectorlib/rtl")

    return lib
