from lambdalib import Lambda


class Oa222(Lambda):
    def __init__(self):
        name = 'la_oa222'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Oa222()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
