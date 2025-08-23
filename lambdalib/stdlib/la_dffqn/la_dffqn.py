from lambdalib.lambdalib import Lambda


class Dffqn(Lambda):
    def __init__(self):
        name = 'la_dffqn'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dffqn()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
