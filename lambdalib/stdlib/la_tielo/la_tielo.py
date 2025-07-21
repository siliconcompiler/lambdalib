from lambdalib import Lambda


class Tielo(Lambda):
    def __init__(self):
        name = 'la_tielo'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Tielo()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
