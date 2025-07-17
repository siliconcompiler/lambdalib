from lambdalib import Lambda


class Header(Lambda):
    def __init__(self):
        name = 'la_header'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Header()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
