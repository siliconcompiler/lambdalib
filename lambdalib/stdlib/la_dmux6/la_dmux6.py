from lambdalib import Lambda


class Dmux6(Lambda):
    def __init__(self):
        name = 'la_dmux6'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dmux6()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
