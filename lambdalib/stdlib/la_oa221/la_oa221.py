from lambdalib.lambdalib import Lambda


class Oa221(Lambda):
    def __init__(self):
        name = 'la_oa221'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oa221()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
