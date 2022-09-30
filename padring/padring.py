import siliconcompiler

chip = siliconcompiler.Chip("la_iopadring")

chip.add('input', 'verilog', 'rtl/la_iopadring.v')
chip.add('option', 'ydir', 'rtl')
chip.add('option', 'idir', 'rtl')
chip.add('option', 'ydir', '../iolib/rtl')
chip.load_target("freepdk45_demo")
chip.set('option', 'quiet', True)
chip.set('option', 'steplist', ['import', 'syn'])
chip.run()
