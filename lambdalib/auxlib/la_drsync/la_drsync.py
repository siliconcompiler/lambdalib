from lambdalib import Lambda


class Drsync(Lambda):
    def __init__(self):
        name = 'la_drsync'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Drsync()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
