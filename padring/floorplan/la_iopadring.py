import os
import re
import siliconcompiler


root = os.path.dirname(__file__) + "../../"

topmodule = "la_iopadring"
chip = siliconcompiler.Chip(topmodule)
chip.load_target('skywater130_demo')

chip.set('input', 'verilog', f'{root}/../rtl/la_iopadring.v')
chip.add('option', 'ydir', f'{root}/../padring/rtl/')
chip.add('option', 'ydir', 'iolib/adapter/sky130io/rtl/')
chip.set('option', 'relax', True)
chip.set('option', 'steplist', ['import', 'syn'])
chip.run()
