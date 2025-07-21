import lambdalib as ll


class Clb4p0(ll.Lambda):
    def __init__(self):
        name = 'la_clb4p0'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)
        for dep in [ll.fpgalib.Ble4p0]:
            self.add_depfileset(dep(), depfileset='rtl', fileset='rtl')


if __name__ == "__main__":
    d = Clb4p0()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
