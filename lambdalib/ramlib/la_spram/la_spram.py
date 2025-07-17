from lambdalib import Lambda


class Spram(Lambda):
    def __init__(self):
        name = 'la_spram'
        sources = [f'rtl/{name}.v',
                   f'rtl/la_spram_impl.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Spram()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
