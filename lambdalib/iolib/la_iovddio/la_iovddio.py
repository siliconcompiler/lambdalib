from lambdalib.lambdalib import Lambda


class Iovddio(Lambda):
    def __init__(self):
        name = 'la_iovddio'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iovddio()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
