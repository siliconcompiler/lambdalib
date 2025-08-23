from lambdalib.lambdalib import Lambda


class Ioinput(Lambda):
    def __init__(self):
        name = 'la_ioinput'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ioinput()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
