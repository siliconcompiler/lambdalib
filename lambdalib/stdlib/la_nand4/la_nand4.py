from lambdalib import Lambda


class Nand4(Lambda):
    def __init__(self):
        name = 'la_nand4'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Nand4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
