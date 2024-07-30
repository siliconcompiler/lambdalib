from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib pandring
    '''

    lib = Library(chip, 'lambdalib_padring', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'idir', "lambdalib/padring/rtl")
    lib.add('option', 'ydir', "lambdalib/padring/rtl")

    return lib
