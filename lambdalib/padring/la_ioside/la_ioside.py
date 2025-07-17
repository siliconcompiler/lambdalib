from lambdalib import Lambda


class Ioside(Lambda):
    def __init__(self):
        name = 'la_ioside'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Ioside()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
