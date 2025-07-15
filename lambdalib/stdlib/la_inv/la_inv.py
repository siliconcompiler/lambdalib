from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Inv(DesignSchema):
    def __init__(self):
        name = 'la_inv'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Inv()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
