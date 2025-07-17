from lambdalib import Lambda


class Sdffsq(Lambda):
    def __init__(self):
        name = 'la_sdffsq'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Sdffsq()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
