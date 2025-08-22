from lambdalib.lambdalib import Lambda


class Ioclamp(Lambda):
    def __init__(self):
        name = 'la_ioclamp'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ioclamp()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
