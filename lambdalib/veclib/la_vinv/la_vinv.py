from lambdalib.lambdalib import Lambda


class Vinv(Lambda):
    def __init__(self):
        name = 'la_vinv'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vinv()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
