from lambdalib.lambdalib import Lambda


class Antenna(Lambda):
    def __init__(self):
        name = 'la_antenna'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Antenna()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
