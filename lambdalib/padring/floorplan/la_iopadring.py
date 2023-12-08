import os
import siliconcompiler


root = os.path.dirname(__file__) + "../../"

topmodule = "la_iopadring"
chip = siliconcompiler.Chip(topmodule)
chip.load_target('skywater130_demo')

chip.set('input', 'verilog', f'{root}/padring/rtl/la_iopadring.v')
chip.add('option', 'ydir', f'{root}/padring/rtl/')
chip.add('option', 'ydir',  f'{root}/submodules/openpdks/pdks/sky130/libs/sky130io/lambda')
chip.add('option', 'ydir',  f'{root}/submodules/openpdks/pdks/sky130/libs/sky130io/bb')
chip.set('option', 'relax', True)
chip.set('option', 'steplist', ['import', 'syn', 'floorplan'])
chip.set('asic', 'diearea', [(0, 0), (2000, 2000)])
chip.run()
