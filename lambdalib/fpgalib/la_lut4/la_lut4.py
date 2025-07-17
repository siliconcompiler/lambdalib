from lambdalib import Lambda
from lambdalib.stdlib import Mux2


class Lut4(Lambda):
    def __init__(self):
        name = 'la_lut4'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)
        for dep in [Mux2]:
            self.add_depfileset(dep(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Lut4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
