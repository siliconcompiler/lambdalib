import lambdalib as ll


class Padring(ll.Lambda):
    def __init__(self):
        name = 'la_padring'
        sources = [f'rtl/{name}.v',
                   f'rtl/la_ioside.v']
        super().__init__(name, sources, __file__)

        # extra settings, #TODO: not great, hard-coded names inside Lambda
        self.add_idir('rtl', fileset='rtl', dataroot=name)

        # dependencies
        for dep in [ll.iolib.Iobidir,
                    ll.iolib.Ioinput,
                    ll.iolib.Ioanalog,
                    ll.iolib.Ioxtal,
                    ll.iolib.Iorxdiff,
                    ll.iolib.Iotxdiff,
                    ll.iolib.Iopoc,
                    ll.iolib.Iocut,
                    ll.iolib.Iovddio,
                    ll.iolib.Iovssio,
                    ll.iolib.Iovdd,
                    ll.iolib.Iovss,
                    ll.iolib.Iovdda,
                    ll.iolib.Iovssa,
                    ll.iolib.Ioclamp]:
            self.add_depfileset(dep(), depfileset='rtl', fileset='rtl')

if __name__ == "__main__":
    d = Padring()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
