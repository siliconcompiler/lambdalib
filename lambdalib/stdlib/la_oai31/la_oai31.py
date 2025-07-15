from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Oai31(DesignSchema):
    def __init__(self):
        name = 'la_oai31'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Oai31()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
