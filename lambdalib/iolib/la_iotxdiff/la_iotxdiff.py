from lambdalib import Lambda


class Iotxdiff(Lambda):
    def __init__(self):
        name = 'la_iotxdiff'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Iotxdiff()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
