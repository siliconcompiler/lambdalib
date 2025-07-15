from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Xor2(DesignSchema):
    def __init__(self):
        name = 'la_xor2'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Xor2()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
