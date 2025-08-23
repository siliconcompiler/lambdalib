from lambdalib.lambdalib import Lambda


class Vbuf(Lambda):
    def __init__(self):
        name = 'la_vbuf'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vbuf()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
