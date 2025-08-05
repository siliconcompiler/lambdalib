from lambdalib.lambdalib import Lambda


class Dffsqn(Lambda):
    def __init__(self):
        name = 'la_dffsqn'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dffsqn()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
