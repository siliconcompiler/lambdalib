from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib stdlib
    '''

    lib = Library(chip, 'lambdalib_stdlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "stdlib/rtl")

    return lib
