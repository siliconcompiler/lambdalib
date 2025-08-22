from lambdalib.lambdalib import Lambda

from lambdalib.fpgalib import Lut4
from lambdalib.stdlib import Dffrq
from lambdalib.stdlib import Mux2


class Ble4p0(Lambda):
    def __init__(self):
        name = 'la_ble4p0'
        super().__init__(name, __file__)

        self.add_depfileset(Lut4(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Dffrq(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Mux2(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Ble4p0()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
