from lambdalib.lambdalib import Lambda


class Nand4(Lambda):
    def __init__(self):
        name = 'la_nand4'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Nand4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
