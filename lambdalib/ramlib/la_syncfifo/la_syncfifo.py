from lambdalib.lambdalib import Lambda


class Syncfifo(Lambda):
    def __init__(self):
        name = 'la_syncfifo'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Syncfifo()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
