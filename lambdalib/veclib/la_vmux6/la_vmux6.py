from lambdalib import Lambda


class Vmux6(Lambda):
    def __init__(self):
        name = 'la_vmux6'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Vmux6()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
