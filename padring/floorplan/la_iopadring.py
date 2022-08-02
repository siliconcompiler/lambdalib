import os
import re
import siliconcompiler

topmodule = "la_iopadring"
chip = siliconcompiler.Chip(topmodule)
chip.load_target('skywater130_demo')


chip.set('input', 'verilog', '../rtl/la_iopadring.v')
chip.add('option', 'ydir', '../rtl/')
chip.add('option', 'ydir', '../../iolib/adapter/sky130io/rtl')
chip.set('option', 'steplist', ['import', 'syn'])
chip.run()
