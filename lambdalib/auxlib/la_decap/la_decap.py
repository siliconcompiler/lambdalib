from lambdalib.lambdalib import Lambda


class Decap(Lambda):
    def __init__(self):
        name = 'la_decap'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Decap()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
