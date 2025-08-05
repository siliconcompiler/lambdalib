from lambdalib.lambdalib import Lambda


class Ao33(Lambda):
    def __init__(self):
        name = 'la_ao33'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ao33()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
