from lambdalib import Lambda


class Asyncfifo(Lambda):
    def __init__(self):
        name = 'la_asyncfifo'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Asyncfifo()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
