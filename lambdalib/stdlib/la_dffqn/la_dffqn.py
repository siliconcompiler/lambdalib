from lambdalib import Lambda


class Dffqn(Lambda):
    def __init__(self):
        name = 'la_dffqn'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dffqn()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
