from lambdalib.lambdalib import Lambda

from lambdalib.auxlib import Drsync


class Asyncfifo(Lambda):
    def __init__(self):
        name = 'la_asyncfifo'
        super().__init__(name, __file__)

        self.add_depfileset(Drsync(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Asyncfifo()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
