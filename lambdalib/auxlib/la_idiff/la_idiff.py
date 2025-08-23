from lambdalib.lambdalib import Lambda


class Idiff(Lambda):
    def __init__(self):
        name = 'la_idiff'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Idiff()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
