from lambdalib.lambdalib import Lambda


class Inv(Lambda):
    def __init__(self):
        name = 'la_inv'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Inv()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
