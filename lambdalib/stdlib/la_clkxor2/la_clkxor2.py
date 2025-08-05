from lambdalib.lambdalib import Lambda


class Clkxor2(Lambda):
    def __init__(self):
        name = 'la_clkxor2'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Clkxor2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
