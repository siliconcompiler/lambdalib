from siliconcompiler import Library
import lambdalib._common
import lambdalib.iolib


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib padring
    '''

    lib = Library('lambdalib_padring', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'idir', "padring/rtl")
    lib.add('option', 'ydir', "padring/rtl")

    lib.use(lambdalib.iolib)

    return lib
