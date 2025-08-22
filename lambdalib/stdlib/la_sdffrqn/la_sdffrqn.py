from lambdalib.lambdalib import Lambda


class Sdffrqn(Lambda):
    def __init__(self):
        name = 'la_sdffrqn'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Sdffrqn()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
