from lambdalib import Lambda


class Ioanalog(Lambda):
    def __init__(self):
        name = 'la_ioanalog'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Ioanalog()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
