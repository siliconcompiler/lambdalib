from lambdalib.lambdalib import Lambda


class Clkinv(Lambda):
    def __init__(self):
        name = 'la_clkinv'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Clkinv()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
