from lambdalib import Lambda


class Iovss(Lambda):
    def __init__(self):
        name = 'la_iovss'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iovss()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
