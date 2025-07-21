from lambdalib import Lambda


class Iobidir(Lambda):
    def __init__(self):
        name = 'la_iobidir'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iobidir()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
