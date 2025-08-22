from lambdalib.lambdalib import Lambda


class Iovdda(Lambda):
    def __init__(self):
        name = 'la_iovdda'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iovdda()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
