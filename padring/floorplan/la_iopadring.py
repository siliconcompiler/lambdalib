import os
import re
import siliconcompiler

topmodule = "la_iopadring"
chip = siliconcompiler.Chip(topmodule)
chip.load_target('skywater130_demo')

chip.set('input', 'verilog', 'padring/rtl/la_iopadring.v')
chip.add('input', 'verilog', 'skywater/skywater130/libs/sky130io/v0_0_2/io/sky130_io.blackbox.v')
chip.add('option', 'ydir', 'padring/rtl/')
chip.add('option', 'ydir', 'iolib/adapter/sky130io/rtl/')
chip.set('option', 'relax', True)
chip.set('option', 'steplist', ['import', 'syn'])
chip.run()
