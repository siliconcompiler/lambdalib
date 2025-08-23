from lambdalib.lambdalib import Lambda


class Isohi(Lambda):
    def __init__(self):
        name = 'la_isohi'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Isohi()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
