from lambdalib.lambdalib import Lambda

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
        self.add_depfileset(Inv(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(And2(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Clkor2(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Drsync(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Clkicgand(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Clkmux2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
