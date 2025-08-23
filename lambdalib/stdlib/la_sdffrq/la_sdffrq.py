from lambdalib.lambdalib import Lambda


class Sdffrq(Lambda):
    def __init__(self):
        name = 'la_sdffrq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Sdffrq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
