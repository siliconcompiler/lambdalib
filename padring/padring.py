import siliconcompiler

chip = siliconcompiler.Chip("la_iopadring")

chip.add('option', 'ydir', 'rtl')
chip.add('option', 'ydir', '../iolib/rtl')
chip.add('input', 'verilog','rtl/la_iopadring.v')
chip.load_target("freepdk45_demo")
chip.set('option', 'quiet', True)
chip.set('option', 'track', True)
chip.run()
