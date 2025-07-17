from lambdalib import Lambda


class Ao221(Lambda):
    def __init__(self):
        name = 'la_ao221'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Ao221()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
