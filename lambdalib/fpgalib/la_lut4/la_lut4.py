from lambdalib.lambdalib import Lambda
from lambdalib.stdlib import Mux2


class Lut4(Lambda):
    def __init__(self):
        name = 'la_lut4'
        super().__init__(name, __file__)

        self.add_depfileset(Mux2(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Lut4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
