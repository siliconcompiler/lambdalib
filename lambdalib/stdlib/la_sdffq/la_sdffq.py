from lambdalib import Lambda


class Sdffq(Lambda):
    def __init__(self):
        name = 'la_sdffq'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Sdffq()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
