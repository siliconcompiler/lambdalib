########################################
# Old SiliconCompiler Setup (deprecated)
########################################
from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import iolib

def setup():
    '''
    Lambdalib padring
    '''

    lib = Library('lambdalib_padring', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    cells = ['la_ioside',
             'la_iopadring']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')

    lib.add('option', 'idir', "padring/include")

    lib.use(iolib)

    return lib
