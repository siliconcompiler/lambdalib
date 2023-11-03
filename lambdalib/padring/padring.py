import siliconcompiler
import os


########################
# SiliconCompiler Setup
########################
def setup(target=None):
    '''Lambdalib Padring Setup'''

    # Create chip object
    chip = siliconcompiler.Chip('la_iopadring')

    # Project sources
    root = os.path.dirname(__file__)
    chip.add('input', 'verilog', f"{root}/rtl/la_iopadring.v")
    chip.add('input', 'verilog', f"{root}/rtl/la_ioside.v")
    chip.add('option', 'idir', f"{root}/rtl")

    return chip
