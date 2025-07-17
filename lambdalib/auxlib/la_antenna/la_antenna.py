from lambdalib import Lambda


class Antenna(Lambda):
    def __init__(self):
        name = 'la_antenna'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Antenna()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
