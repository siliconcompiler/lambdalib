from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib auxlib
    '''

    lib = Library(chip, 'lambdalib_auxlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "lambdalib/auxlib/rtl")

    return lib
