from lambdalib import Lambda


class Ioxtal(Lambda):
    def __init__(self):
        name = 'la_ioxtal'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Ioxtal()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
