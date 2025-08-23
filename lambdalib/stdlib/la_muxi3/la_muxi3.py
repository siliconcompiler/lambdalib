from lambdalib.lambdalib import Lambda


class Muxi3(Lambda):
    def __init__(self):
        name = 'la_muxi3'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Muxi3()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
