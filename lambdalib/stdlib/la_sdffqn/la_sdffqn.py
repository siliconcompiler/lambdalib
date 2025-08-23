from lambdalib.lambdalib import Lambda


class Sdffqn(Lambda):
    def __init__(self):
        name = 'la_sdffqn'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Sdffqn()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
