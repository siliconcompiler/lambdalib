from lambdalib.lambdalib import Lambda


class Oai33(Lambda):
    def __init__(self):
        name = 'la_oai33'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Oai33()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
