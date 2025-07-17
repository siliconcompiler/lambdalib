from lambdalib import Lambda


class Xor4(Lambda):
    def __init__(self):
        name = 'la_xor4'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Xor4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
