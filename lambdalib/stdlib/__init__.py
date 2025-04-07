from siliconcompiler import Library
import lambdalib._common.register_data_source


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib stdlib
    '''

    lib = Library('lambdalib_stdlib', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'ydir', "stdlib/rtl")

    return lib
