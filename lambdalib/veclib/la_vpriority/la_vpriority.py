from lambdalib.lambdalib import Lambda


class Vpriority(Lambda):
    def __init__(self):
        name = 'la_vpriority'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Vpriority()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
