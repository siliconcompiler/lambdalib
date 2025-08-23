from lambdalib.lambdalib import Lambda


class Oa32(Lambda):
    def __init__(self):
        name = 'la_oa32'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oa32()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
