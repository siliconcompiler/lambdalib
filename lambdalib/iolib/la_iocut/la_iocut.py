from lambdalib import Lambda


class Iocut(Lambda):
    def __init__(self):
        name = 'la_iocut'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iocut()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
