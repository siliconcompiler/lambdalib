from siliconcompiler import Library
import lambdalib._common
import lambdalib.stdlib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib auxlib
    '''

    lib = Library('lambdalib_auxlib', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'ydir', "auxlib/rtl")

    lib.use(lambdalib.stdlib)

    return lib
