from lambdalib import Lambda


class Iopadring(Lambda):
    def __init__(self):
        name = 'la_iopadring'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iopadring()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
