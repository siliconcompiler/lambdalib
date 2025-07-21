from lambdalib import Lambda


class Idiff(Lambda):
    def __init__(self):
        name = 'la_idiff'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Idiff()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
