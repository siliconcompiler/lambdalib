from lambdalib import Lambda


class Delay(Lambda):
    def __init__(self):
        name = 'la_delay'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Delay()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
