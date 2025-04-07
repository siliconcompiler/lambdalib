from siliconcompiler import Library
import lambdalib._common


########################
# SiliconCompiler Setup
########################
def setup():
    '''
    Lambdalib fpgalib
    '''

    lib = Library('lambdalib_fpgalib', package='lambdalib', auto_enable=True)
    lambdalib._common.register_data_source(lib)

    lib.add('option', 'ydir', "fpgalib/rtl")

    return lib
