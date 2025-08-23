from lambdalib.lambdalib import Lambda


class Dmux5(Lambda):
    def __init__(self):
        name = 'la_dmux5'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dmux5()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
