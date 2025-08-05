from lambdalib.lambdalib import Lambda


class Xor2(Lambda):
    def __init__(self):
        name = 'la_xor2'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Xor2()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
