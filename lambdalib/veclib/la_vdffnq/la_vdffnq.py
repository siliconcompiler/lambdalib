from lambdalib.lambdalib import Lambda


class Vdffnq(Lambda):
    def __init__(self):
        name = 'la_vdffnq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vdffnq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
