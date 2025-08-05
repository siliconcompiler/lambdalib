from lambdalib.lambdalib import Lambda


class Aoi221(Lambda):
    def __init__(self):
        name = 'la_aoi221'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Aoi221()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
