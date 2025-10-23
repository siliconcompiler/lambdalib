from lambdalib.lambdalib import Lambda


class Vdffq(Lambda):
    def __init__(self):
        name = 'la_dffq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vdffq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
