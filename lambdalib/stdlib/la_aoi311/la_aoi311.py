from lambdalib.lambdalib import Lambda


class Aoi311(Lambda):
    def __init__(self):
        name = 'la_aoi311'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Aoi311()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
