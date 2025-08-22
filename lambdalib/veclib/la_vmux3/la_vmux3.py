from lambdalib.lambdalib import Lambda


class Vmux3(Lambda):
    def __init__(self):
        name = 'la_vmux3'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vmux3()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
