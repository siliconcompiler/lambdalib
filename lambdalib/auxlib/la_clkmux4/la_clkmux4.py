from lambdalib import Lambda


class Clkmux4(Lambda):
    def __init__(self):
        name = 'la_clkmux4'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Clkmux4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
