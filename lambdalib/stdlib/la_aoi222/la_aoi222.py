from lambdalib.lambdalib import Lambda


class Aoi222(Lambda):
    def __init__(self):
        name = 'la_aoi222'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Aoi222()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
