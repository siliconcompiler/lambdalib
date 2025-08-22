from lambdalib.lambdalib import Lambda


class Xnor4(Lambda):
    def __init__(self):
        name = 'la_xnor4'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Xnor4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
