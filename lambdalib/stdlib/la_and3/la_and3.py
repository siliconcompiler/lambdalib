from lambdalib.lambdalib import Lambda


class And3(Lambda):
    def __init__(self):
        name = 'la_and3'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = And3()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
