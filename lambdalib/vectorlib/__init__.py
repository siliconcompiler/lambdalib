from siliconcompiler import Library
import lambdalib._common
import lambdalib.stdlib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib vectorlib
    '''

    lib = Library('lambdalib_vectorlib', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'ydir', "vectorlib/rtl")

    lib.use(lambdalib.stdlib)

    return lib
