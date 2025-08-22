from lambdalib.lambdalib import Lambda

from lambdalib.fpgalib import Ble4p0


class Clb4p0(Lambda):
    def __init__(self):
        name = 'la_clb4p0'
        super().__init__(name, __file__)

        self.add_depfileset(Ble4p0(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Clb4p0()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
