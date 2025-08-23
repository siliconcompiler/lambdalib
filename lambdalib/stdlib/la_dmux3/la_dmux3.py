from lambdalib.lambdalib import Lambda


class Dmux3(Lambda):
    def __init__(self):
        name = 'la_dmux3'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dmux3()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
