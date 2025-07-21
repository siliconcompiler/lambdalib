from lambdalib import Lambda


class Dmux5(Lambda):
    def __init__(self):
        name = 'la_dmux5'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dmux5()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
