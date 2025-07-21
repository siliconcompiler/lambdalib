from lambdalib import Lambda


class Clkbuf(Lambda):
    def __init__(self):
        name = 'la_clkbuf'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Clkbuf()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
