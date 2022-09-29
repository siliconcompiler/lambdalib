import siliconcompiler

chip = siliconcompiler.Chip("la_iopadring")

ioroot = "/home/aolofsson/work/zeroasic/sclib/pdks/gf12lp/libs/io_gppr_t18_mv10_mv18_fs18_rvt_dr/"

chip.add('input', 'verilog','rtl/la_iopadring.v')
chip.add('option', 'ydir', 'rtl')
chip.add('option', 'idir', 'rtl')
chip.add('option', 'ydir', '../lambdalib/stdlib/rtl')
chip.add('option', 'ydir', f'{ioroot}/lambda')
chip.add('input', 'verilog', f'{ioroot}/bb/io_gppr_12lp_t18_mv10_mv18_fs18_rvt_dr.v')
chip.load_target("freepdk45_demo")
chip.set('option', 'quiet', True)
chip.run()
