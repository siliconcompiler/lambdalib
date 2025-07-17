from lambdalib import Lambda


class Nor3(Lambda):
    def __init__(self):
        name = 'la_nor3'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Nor3()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
