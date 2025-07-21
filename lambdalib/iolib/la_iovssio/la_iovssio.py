from lambdalib import Lambda


class Iovssio(Lambda):
    def __init__(self):
        name = 'la_iovssio'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iovssio()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
