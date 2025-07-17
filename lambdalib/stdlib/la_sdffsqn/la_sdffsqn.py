from lambdalib import Lambda


class Sdffsqn(Lambda):
    def __init__(self):
        name = 'la_sdffsqn'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Sdffsqn()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
