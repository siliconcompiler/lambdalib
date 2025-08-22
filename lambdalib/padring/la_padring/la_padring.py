from lambdalib.lambdalib import Lambda

from lambdalib.iolib import IOLib


class Padring(Lambda):
    def __init__(self):
        name = 'la_padring'
        super().__init__(name, __file__, extrasources=["rtl/la_padside.v"])

        # extra settings
        with self.active_fileset("rtl"):
            self.set_topmodule(name)

            with self.active_dataroot(name):
                self.add_idir("rtl")

            # dependencies
            self.add_depfileset(IOLib(), depfileset='rtl')


if __name__ == "__main__":
    d = Padring()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
