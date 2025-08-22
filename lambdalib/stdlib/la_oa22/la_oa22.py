from lambdalib.lambdalib import Lambda


class Oa22(Lambda):
    def __init__(self):
        name = 'la_oa22'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oa22()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
