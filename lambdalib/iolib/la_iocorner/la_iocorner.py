from lambdalib import Lambda


class Iocorner(Lambda):
    def __init__(self):
        name = 'la_iocorner'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iocorner()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
