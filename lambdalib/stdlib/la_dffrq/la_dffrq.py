from lambdalib import Lambda


class Dffrq(Lambda):
    def __init__(self):
        name = 'la_dffrq'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dffrq()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
