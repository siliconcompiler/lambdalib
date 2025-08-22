from lambdalib.lambdalib import Lambda

from lambdalib.stdlib import Inv
from lambdalib.stdlib import And2
from lambdalib.stdlib import Or3
from lambdalib.stdlib import Clkor4
from lambdalib.auxlib import Drsync
from lambdalib.auxlib import Clkicgand


class Clkmux4(Lambda):
    def __init__(self):
        name = 'la_clkmux4'
        super().__init__(name, __file__)

        # dependencies
        self.add_depfileset(Inv(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(And2(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Or3(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Clkor4(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Drsync(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Clkicgand(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Clkmux4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
