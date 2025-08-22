from lambdalib.lambdalib import Lambda


class Iobidir(Lambda):
    def __init__(self):
        name = 'la_iobidir'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iobidir()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
