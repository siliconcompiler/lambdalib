from lambdalib import Lambda


class Decap(Lambda):
    def __init__(self):
        name = 'la_decap'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Decap()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
