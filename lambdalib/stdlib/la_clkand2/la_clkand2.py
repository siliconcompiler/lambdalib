from lambdalib.lambdalib import Lambda


class Clkand2(Lambda):
    def __init__(self):
        name = 'la_clkand2'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Clkand2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
