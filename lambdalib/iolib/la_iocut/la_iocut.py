from lambdalib.lambdalib import Lambda


class Iocut(Lambda):
    def __init__(self):
        name = 'la_iocut'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iocut()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
