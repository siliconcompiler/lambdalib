from lambdalib.lambdalib import Lambda


class Dffrqn(Lambda):
    def __init__(self):
        name = 'la_dffrqn'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dffrqn()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
