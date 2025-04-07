from siliconcompiler import Library
import lambdalib._common.register_data_source


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib iolib
    '''

    lib = Library('lambdalib_iolib', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'ydir', "iolib/rtl")

    return lib
