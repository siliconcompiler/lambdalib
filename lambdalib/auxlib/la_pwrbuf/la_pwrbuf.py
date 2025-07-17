from lambdalib import Lambda


class Pwrbuf(Lambda):
    def __init__(self):
        name = 'la_pwrbuf'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)


if __name__ == "__main__":
    d = Pwrbuf()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
