from lambdalib import Lambda


class Dmux8(Lambda):
    def __init__(self):
        name = 'la_dmux8'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dmux8()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
