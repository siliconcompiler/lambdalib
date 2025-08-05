from lambdalib.lambdalib import Lambda


class Clkicgor(Lambda):
    def __init__(self):
        name = 'la_clkicgor'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Clkicgor()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
