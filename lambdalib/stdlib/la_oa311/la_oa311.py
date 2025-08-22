from lambdalib.lambdalib import Lambda


class Oa311(Lambda):
    def __init__(self):
        name = 'la_oa311'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oa311()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
