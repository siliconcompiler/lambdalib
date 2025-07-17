import lambdalib as ll

class Asyncfifo(ll.Lambda):
    def __init__(self):
        name = 'la_asyncfifo'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

        for dep in [ll.auxlib.Drsync]:
            self.add_depfileset(dep(), depfileset='rtl', fileset='rtl')

if __name__ == "__main__":
    d = Asyncfifo()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
