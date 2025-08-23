from lambdalib.lambdalib import Lambda


class Dffnq(Lambda):
    def __init__(self):
        name = 'la_dffnq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dffnq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
