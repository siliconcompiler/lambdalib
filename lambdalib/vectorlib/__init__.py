from siliconcompiler import Library
from lambdalib._common import register_data_source
import lambdalib.stdlib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib vectorlib
    '''

    lib = Library('lambdalib_vectorlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'ydir', "vectorlib/rtl")

    lib.use(lambdalib.stdlib)

    return lib
