from lambdalib import Lambda


class Buf(Lambda):
    def __init__(self):
        name = 'la_buf'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Buf()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
