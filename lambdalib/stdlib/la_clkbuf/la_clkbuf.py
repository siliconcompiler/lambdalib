from lambdalib.lambdalib import Lambda


class Clkbuf(Lambda):
    def __init__(self):
        name = 'la_clkbuf'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Clkbuf()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
