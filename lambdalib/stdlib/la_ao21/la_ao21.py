from lambdalib.lambdalib import Lambda


class Ao21(Lambda):
    def __init__(self):
        name = 'la_ao21'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ao21()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
