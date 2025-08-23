from lambdalib.lambdalib import Lambda


class Obuf(Lambda):
    def __init__(self):
        name = 'la_obuf'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Obuf()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
