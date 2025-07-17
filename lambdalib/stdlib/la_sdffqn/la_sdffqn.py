from lambdalib import Lambda


class Sdffqn(Lambda):
    def __init__(self):
        name = 'la_sdffqn'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Sdffqn()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
