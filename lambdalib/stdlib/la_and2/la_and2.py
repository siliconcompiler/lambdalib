from lambdalib import Lambda


class And2(Lambda):
    def __init__(self):
        name = 'la_and2'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = And2()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
