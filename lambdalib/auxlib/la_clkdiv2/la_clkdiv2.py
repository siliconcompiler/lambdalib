from lambdalib.lambdalib import Lambda
from siliconcompiler import Design
from lambdalib.stdlib import Inv
from lambdalib.stdlib import Dffrq


class Clkdiv2(Lambda):
    def __init__(self):
        name = 'la_clkdiv2'
        super().__init__(name, __file__)

        # dependencies
        deps = [Inv(), Dffrq()]
        with self.active_fileset('rtl'):
            for item in deps:
                self.add_depfileset(item)


class Clkdiv2TB(Design):
    def __init__(self):
        name = 'tb_la_clkdiv2'
        super().__init__(name)

        # dependencies
        self.set_dataroot(name, __file__)
        with self.active_fileset('rtl'):
            self.add_file(f"testbench/{name}.v")
            self.add_depfileset(Clkdiv2())


if __name__ == "__main__":
    d = Clkdiv2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
    d = Clkdiv2TB()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
