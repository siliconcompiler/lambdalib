from siliconcompiler import Library
from lambdalib._common import register_data_source
import lambdalib.iolib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib padring
    '''

    lib = Library('lambdalib_padring', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    lib.add('option', 'idir', "padring/rtl")
    lib.add('option', 'ydir', "padring/rtl")

    lib.use(lambdalib.iolib)

    return lib
