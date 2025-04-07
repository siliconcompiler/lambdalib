from siliconcompiler import Library
import lambdalib._common.register_data_source
import lambdalib.auxlib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib ramlib
    '''

    lib = Library('lambdalib_ramlib', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'ydir', "ramlib/rtl")

    lib.use(lambdalib.auxlib)

    return lib
