from lambdalib.lambdalib import Lambda


class And4(Lambda):
    def __init__(self):
        name = 'la_and4'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = And4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
