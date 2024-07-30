from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import iolib


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''
    Lambdalib padring
    '''

    lib = Library(chip, 'lambdalib_padring', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'idir', "padring/rtl")
    lib.add('option', 'ydir', "padring/rtl")

    lib.use(iolib)

    return lib
