from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib iolib
    '''

    lib = Library('lambdalib_iolib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "iolib/rtl")

    return lib
