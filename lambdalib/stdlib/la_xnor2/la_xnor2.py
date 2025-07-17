from lambdalib import Lambda


class Xnor2(Lambda):
    def __init__(self):
        name = 'la_xnor2'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Xnor2()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
