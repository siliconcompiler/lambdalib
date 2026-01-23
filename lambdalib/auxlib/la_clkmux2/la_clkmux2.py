from lambdalib.lambdalib import Lambda
from siliconcompiler import Design
from lambdalib.stdlib import Inv
from lambdalib.stdlib import And2
from lambdalib.stdlib import Clkor2
from lambdalib.auxlib import Drsync
from lambdalib.auxlib import Clkicgand


class Clkmux2(Lambda):
    def __init__(self):
        name = 'la_clkmux2'
        super().__init__(name, __file__)

        # dependencies
        deps = [Inv(), And2(), Clkor2(), Drsync(), Clkicgand()]
        with self.active_fileset('rtl'):
            for item in deps:
                self.add_depfileset(item)

class Clkmux2TB(Design):
    def __init__(self):
        name = 'tb_la_clkmux2'
        super().__init__(name)

        # dependencies
        self.set_dataroot(name, __file__)
        with self.active_fileset('rtl'):
            self.add_file(f"testbench/{name}.v")
            self.add_depfileset(Clkmux2())

if __name__ == "__main__":
    d = Clkmux2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
    d = Clkmux2TB()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
