from lambdalib.lambdalib import Lambda


class Odiff(Lambda):
    def __init__(self):
        name = 'la_odiff'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Odiff()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
