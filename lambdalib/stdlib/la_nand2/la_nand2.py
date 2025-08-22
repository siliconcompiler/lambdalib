from lambdalib.lambdalib import Lambda


class Nand2(Lambda):
    def __init__(self):
        name = 'la_nand2'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Nand2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
