from lambdalib.lambdalib import Lambda


class Ioxtal(Lambda):
    def __init__(self):
        name = 'la_ioxtal'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ioxtal()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
