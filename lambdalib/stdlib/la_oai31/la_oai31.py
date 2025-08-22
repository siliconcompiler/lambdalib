from lambdalib.lambdalib import Lambda


class Oai31(Lambda):
    def __init__(self):
        name = 'la_oai31'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oai31()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
