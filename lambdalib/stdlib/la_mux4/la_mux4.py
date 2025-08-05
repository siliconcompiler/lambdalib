from lambdalib.lambdalib import Lambda


class Mux4(Lambda):
    def __init__(self):
        name = 'la_mux4'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Mux4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
