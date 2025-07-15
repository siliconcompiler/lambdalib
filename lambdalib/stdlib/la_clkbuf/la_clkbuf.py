from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Clkbuf(DesignSchema):
    def __init__(self):
        name = 'la_clkbuf'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Clkbuf()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
