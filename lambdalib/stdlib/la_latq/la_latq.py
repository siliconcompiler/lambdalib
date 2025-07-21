from lambdalib import Lambda


class Latq(Lambda):
    def __init__(self):
        name = 'la_latq'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Latq()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
