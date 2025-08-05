from lambdalib.lambdalib import Lambda


class Aoi31(Lambda):
    def __init__(self):
        name = 'la_aoi31'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Aoi31()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
