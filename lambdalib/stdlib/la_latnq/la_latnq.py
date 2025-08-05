from lambdalib.lambdalib import Lambda


class Latnq(Lambda):
    def __init__(self):
        name = 'la_latnq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Latnq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
