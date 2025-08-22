from lambdalib.lambdalib import Lambda


class Iovdd(Lambda):
    def __init__(self):
        name = 'la_iovdd'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iovdd()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
