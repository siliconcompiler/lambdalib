from lambdalib.lambdalib import Lambda
from lambdalib.auxlib import Clkicgand
from lambdalib.auxlib import Drsync


class Vclkmux(Lambda):
    def __init__(self):
        name = 'la_vclkmux'
        super().__init__(name, __file__)

        # dependencies
        deps = [Drsync(), Clkicgand()]
        with self.active_fileset('rtl'):
            for item in deps:
                self.add_depfileset(item)


if __name__ == "__main__":
    d = Vclkmux()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
