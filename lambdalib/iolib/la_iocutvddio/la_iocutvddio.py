from lambdalib.lambdalib import Lambda


class Iocutvddio(Lambda):
    def __init__(self):
        name = 'la_iocutvddio'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iocutvddio()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
