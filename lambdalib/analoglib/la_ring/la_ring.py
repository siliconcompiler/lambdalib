from lambdalib.lambdalib import Lambda
from lambdalib.stdlib import Inv
from lambdalib.stdlib import Nand2


class Ring(Lambda):
    def __init__(self):
        name = 'la_ring'
        super().__init__(name, __file__)

        # deps
        self.add_depfileset(Inv(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Nand2(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Ring()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
