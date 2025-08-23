from lambdalib.lambdalib import Lambda


class Iddr(Lambda):
    def __init__(self):
        name = 'la_iddr'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iddr()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
