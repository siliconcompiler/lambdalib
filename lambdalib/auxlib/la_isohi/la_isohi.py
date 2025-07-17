from lambdalib import Lambda


class Isohi(Lambda):
    def __init__(self):
        name = 'la_isohi'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Isohi()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
