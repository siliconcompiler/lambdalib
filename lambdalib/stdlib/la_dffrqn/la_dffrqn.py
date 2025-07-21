from lambdalib import Lambda


class Dffrqn(Lambda):
    def __init__(self):
        name = 'la_dffrqn'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dffrqn()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
