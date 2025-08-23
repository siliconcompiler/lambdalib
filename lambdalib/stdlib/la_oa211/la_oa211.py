from lambdalib.lambdalib import Lambda


class Oa211(Lambda):
    def __init__(self):
        name = 'la_oa211'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oa211()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
