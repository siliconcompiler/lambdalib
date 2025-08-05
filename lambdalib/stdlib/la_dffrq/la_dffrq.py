from lambdalib.lambdalib import Lambda


class Dffrq(Lambda):
    def __init__(self):
        name = 'la_dffrq'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Dffrq()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
