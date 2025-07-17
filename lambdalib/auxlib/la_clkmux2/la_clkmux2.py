import lambdalib as ll

class Clkmux2(ll.Lambda):
    def __init__(self):
        name = 'la_clkmux2'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)
        # dependencies
        for dep in [ll.stdlib.Inv,
                    ll.stdlib.And2,
                    ll.stdlib.Clkor2,
                    ll.auxlib.Drsync,
                    ll.auxlib.Clkicgand]:
            self.add_depfileset(dep(), depfileset='rtl', fileset='rtl')

if __name__ == "__main__":
    d = Clkmux2()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
