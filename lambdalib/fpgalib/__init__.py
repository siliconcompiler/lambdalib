from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib fpgalib
    '''

    lib = Library('lambdalib_fpgalib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "fpgalib/rtl")

    return lib
