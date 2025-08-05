from lambdalib.lambdalib import Lambda


class Ioalias(Lambda):
    def __init__(self):
        name = 'la_ioalias'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ioalias()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
