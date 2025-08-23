from lambdalib.lambdalib import Lambda


class Tiehi(Lambda):
    def __init__(self):
        name = 'la_tiehi'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Tiehi()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
