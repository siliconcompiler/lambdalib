from lambdalib.lambdalib import Lambda


class Vmux5(Lambda):
    def __init__(self):
        name = 'la_vmux5'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vmux5()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
