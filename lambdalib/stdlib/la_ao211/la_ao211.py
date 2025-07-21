from lambdalib import Lambda


class Ao211(Lambda):
    def __init__(self):
        name = 'la_ao211'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Ao211()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
