from lambdalib.lambdalib import Lambda


class Iovssa(Lambda):
    def __init__(self):
        name = 'la_iovssa'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iovssa()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
