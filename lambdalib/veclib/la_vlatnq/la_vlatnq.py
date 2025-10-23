from lambdalib.lambdalib import Lambda


class Vlatnq(Lambda):
    def __init__(self):
        name = 'la_vlatnq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vlatnq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
