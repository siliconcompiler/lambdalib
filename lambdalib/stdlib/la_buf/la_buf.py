from lambdalib.lambdalib import Lambda


class Buf(Lambda):
    def __init__(self):
        name = 'la_buf'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Buf()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
