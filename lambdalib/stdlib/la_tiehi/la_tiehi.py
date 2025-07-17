from lambdalib import Lambda


class Tiehi(Lambda):
    def __init__(self):
        name = 'la_tiehi'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Tiehi()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
