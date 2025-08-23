from lambdalib.lambdalib import Lambda


class Or4(Lambda):
    def __init__(self):
        name = 'la_or4'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Or4()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
