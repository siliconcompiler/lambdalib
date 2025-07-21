from lambdalib import Lambda


class Clkicgor(Lambda):
    def __init__(self):
        name = 'la_clkicgor'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Clkicgor()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
