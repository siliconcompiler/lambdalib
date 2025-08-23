from lambdalib.lambdalib import Lambda


class Ioshort(Lambda):
    def __init__(self):
        name = 'la_ioshort'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ioshort()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
