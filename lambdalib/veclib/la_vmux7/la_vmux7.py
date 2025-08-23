from lambdalib.lambdalib import Lambda


class Vmux7(Lambda):
    def __init__(self):
        name = 'la_vmux7'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vmux7()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
