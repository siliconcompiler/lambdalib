from lambdalib.lambdalib import Lambda


class Vmux2b(Lambda):
    def __init__(self):
        name = 'la_vmux2b'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vmux2b()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
