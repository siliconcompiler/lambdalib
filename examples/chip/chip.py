import lambdalib as ll
from siliconcompiler import DesignSchema

class Chip(DesignSchema):
    def __init__(self):

        name = 'chip'
        super().__init__(name)

        fileset = 'rtl'
        dataroot = f'{name}'
        topmodule = name

        sources = [f'rtl/{name}.v']

        self.set_dataroot(dataroot, __file__)
        self.set_topmodule(topmodule, fileset)

        for item in sources:
            self.add_file(item, fileset, dataroot=dataroot)

        self.add_idir('rtl', fileset, dataroot=dataroot)

        # dependencies
        for dep in [ll.padring.Padring]:
            self.add_depfileset(dep(), depfileset='rtl', fileset='rtl')

if __name__ == "__main__":
    d = Chip()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
    cmd = ['yosys', '-f', script]
    return subprocess.run(cmd,
                          stderr=subprocess.STDOUT,
                          check=True)
