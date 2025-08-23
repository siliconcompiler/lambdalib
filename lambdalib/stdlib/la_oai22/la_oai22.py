from lambdalib.lambdalib import Lambda


class Oai22(Lambda):
    def __init__(self):
        name = 'la_oai22'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oai22()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
