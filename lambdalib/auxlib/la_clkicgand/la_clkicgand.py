from lambdalib.lambdalib import Lambda


class Clkicgand(Lambda):
    def __init__(self):
        name = 'la_clkicgand'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Clkicgand()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
