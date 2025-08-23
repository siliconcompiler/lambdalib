import subprocess

from siliconcompiler import DesignSchema

from lambdalib.padring import Padring


class Chip(DesignSchema):
    def __init__(self):

        name = 'chip'
        super().__init__(name)

        fileset = 'rtl'
        dataroot = f'{name}'
        topmodule = name

        self.set_dataroot(dataroot, __file__)
        self.set_topmodule(topmodule, fileset)

        self.add_file("rtl/chip.v", fileset, dataroot=dataroot)
        self.add_idir('rtl', fileset, dataroot=dataroot)

        # dependencies
        self.add_depfileset(Padring(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Chip()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
    cmd = ['yosys', '-f', f"{d.name}.f"]
    subprocess.run(cmd, stderr=subprocess.STDOUT, check=True)
