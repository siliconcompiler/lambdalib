from lambdalib.lambdalib import Lambda


class Vmux8(Lambda):
    def __init__(self):
        name = 'la_vmux8'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vmux8()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
