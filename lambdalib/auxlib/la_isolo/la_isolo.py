from lambdalib.lambdalib import Lambda


class Isolo(Lambda):
    def __init__(self):
        name = 'la_isolo'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Isolo()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
