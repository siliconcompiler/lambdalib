from lambdalib import Lambda


class Dsync(Lambda):
    def __init__(self):
        name = 'la_dsync'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dsync()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
