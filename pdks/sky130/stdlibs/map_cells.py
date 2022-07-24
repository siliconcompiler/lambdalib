import glob, re, os
import siliconcompiler

run = True

dontcheck = ['la_keeper',
             'la_antenna',
             'la_header',
             'la_isolo',
             'la_isohi',
             'la_footer',
             'la_decap']

for filename in glob.glob('../../../stdlib/rtl/la_*.v'):
    cell = re.sub(r'../../../stdlib/rtl/(.*).v', r'\1',filename)
    if cell not in dontcheck:
        if run:
            chip = siliconcompiler.Chip(cell)
            chip.load_target("skywater130_demo")
            chip.set('input','verilog',filename)
            chip.set('option', 'novercheck', True)
            chip.set('option', 'quiet', True)
            chip.set('option', 'jobname', cell)
            chip.set('option', 'steplist',['import','syn'])
            chip.run()
        # copy synthesis results once
        with open(f"build/{cell}/{cell}/syn/0/outputs/{cell}.vg", "r") as fi:
            with open(f"rtl/{cell}.v", "w") as fo:
                for line in fi:
                    if not re.search(r'git sha1',line):
                        fo.write(line)
