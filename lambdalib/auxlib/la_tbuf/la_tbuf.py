from lambdalib.lambdalib import Lambda


class Tbuf(Lambda):
    def __init__(self):
        name = 'la_tbuf'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Tbuf()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
