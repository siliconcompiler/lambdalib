from lambdalib.lambdalib import Lambda


class Ao221(Lambda):
    def __init__(self):
        name = 'la_ao221'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ao221()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
