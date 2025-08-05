from lambdalib.lambdalib import Lambda


class Dffsq(Lambda):
    def __init__(self):
        name = 'la_dffsq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dffsq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
