import siliconcompiler
import os

########################
# SiliconCompiler Setup
########################

def setup(target=None):
    '''Lambdalib library setup script'''

    # Create chip object
    chip = siliconcompiler.Chip('lambdalib')

    # Project sources
    root = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))

    # Iterate over all libs
    for item in ['iolib', 'stdlib', 'ramlib', 'padring']:
        chip.add('option', 'ydir', f"{root}/{item}/rtl")
        chip.add('option', 'idir', f"{root}/{item}/rtl")

    return chip
