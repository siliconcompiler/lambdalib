from siliconcompiler import Library
from lambdalib._common import register_data_source


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib syslib
    '''

    lib = Library('lambdalib_syslib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "syslib/rtl")

    return lib
