from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Aoi21(DesignSchema):
    def __init__(self):
        name = 'la_aoi21'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Aoi21()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
