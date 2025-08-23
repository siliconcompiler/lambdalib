from lambdalib.lambdalib import Lambda


class Drsync(Lambda):
    def __init__(self):
        name = 'la_drsync'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Drsync()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
