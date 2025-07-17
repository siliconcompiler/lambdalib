from lambdalib import Lambda


class Dpram(Lambda):
    def __init__(self):
        name = 'la_dpram'
        sources = [f'rtl/{name}.v',
                   f'rtl/la_dpram_impl.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Dpram()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
