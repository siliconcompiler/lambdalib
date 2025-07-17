from lambdalib import Lambda


class Iovddio(Lambda):
    def __init__(self):
        name = 'la_iovddio'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iovddio()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
