from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Ioshort(DesignSchema):
    def __init__(self):
        name = 'la_ioshort'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Ioshort()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
