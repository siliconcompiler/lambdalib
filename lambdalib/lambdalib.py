from lambdalib import register_data_source
from siliconcompiler import Library


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''Lambdalib library setup script'''

    dependencies = {
        'iolib': ['stdlib'],
        'stdlib': [],
        'ramlib': ['stdlib'],
        'padring': ['stdlib'],
        'syslib': ['stdlib'],
        'vectorlib': ['stdlib']
    }

    # Project sources
    register_data_source(chip)

    libs = []
    # Iterate over all libs
    for name, dep in dependencies.items():
        lib = Library(chip, f'la_{name}', package='lambdalib')

        for path in [name, *dep]:
            lib.add('option', 'ydir', f"lambdalib/{path}/rtl")
            lib.add('option', 'idir', f"lambdalib/{path}/rtl")

        libs.append(lib)

    return libs
