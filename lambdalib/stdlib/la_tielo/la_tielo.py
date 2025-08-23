from lambdalib.lambdalib import Lambda


class Tielo(Lambda):
    def __init__(self):
        name = 'la_tielo'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Tielo()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
