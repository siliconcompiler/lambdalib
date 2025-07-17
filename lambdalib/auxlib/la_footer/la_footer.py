from lambdalib import Lambda


class Footer(Lambda):
    def __init__(self):
        name = 'la_footer'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Footer()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
