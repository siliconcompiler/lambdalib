from lambdalib import Lambda


class Syncfifo(Lambda):
    def __init__(self):
        name = 'la_syncfifo'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Syncfifo()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
