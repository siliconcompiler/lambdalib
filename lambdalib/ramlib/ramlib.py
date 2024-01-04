import glob
import siliconcompiler
from siliconcompiler.flows import lintflow

def setup(chip, path=None):

    # setup verilog
    files = glob.glob(f'rtl/*.v')
    for item in files:
        chip.input(item)

###########################
if __name__ == "__main__":

    design = "la_syncfifo"
    chip = siliconcompiler.Chip(design)

    # local files
    setup(chip)

    # run lint
    chip.use(lintflow)
    chip.set('option', 'mode', 'sim')
    chip.set('option', 'flow', 'lintflow')
    chip.run()
