from lambdalib import Lambda


class Dffq(Lambda):
    def __init__(self):
        name = 'la_dffq'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dffq()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
