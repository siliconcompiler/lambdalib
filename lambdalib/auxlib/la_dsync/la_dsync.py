from lambdalib.lambdalib import Lambda


class Dsync(Lambda):
    def __init__(self):
        name = 'la_dsync'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dsync()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
