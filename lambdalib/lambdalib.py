from lambdalib import register_data_source
from siliconcompiler import Library


########################
# SiliconCompiler Setup
########################
def setup(chip):
    '''Lambdalib library setup script'''

    dependencies = {
        'iolib': [],
        'stdlib': [],
        'ramlib': ['stdlib'],
        'padring': [],
        'syslib': ['stdlib'],
        'vectorlib': ['stdlib']
    }
    add_idirs = ('padring',)

    libs = []
    # Iterate over all libs
    for name, dep in dependencies.items():
        lib = Library(chip, f'la_{name}', package='lambdalib')
        register_data_source(lib)

        for path in [name, *dep]:
            lib.add('option', 'ydir', f"lambdalib/{path}/rtl")

            if path in add_idirs:
                lib.add('option', 'idir', f"lambdalib/{path}/rtl")

        libs.append(lib)

    return libs
