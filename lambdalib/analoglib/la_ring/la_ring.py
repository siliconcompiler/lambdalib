from lambdalib.lambdalib import Lambda
from lambdalib.stdlib import Inv
from lambdalib.stdlib import Buf
from lambdalib.stdlib import Nand2
from lambdalib.stdlib import Nand3
from lambdalib.stdlib import Nand4
from lambdalib.stdlib import Nor2
from lambdalib.stdlib import Nor3
from lambdalib.stdlib import Nor4


class Ring(Lambda):
    def __init__(self):
        name = 'la_ring'
        super().__init__(name, __file__)

        # deps
        self.add_depfileset(Inv(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Buf(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nand2(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nand3(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nand4(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nor2(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nor3(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nor4(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Ring()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
