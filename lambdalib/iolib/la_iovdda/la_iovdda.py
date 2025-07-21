from lambdalib import Lambda


class Iovdda(Lambda):
    def __init__(self):
        name = 'la_iovdda'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iovdda()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
