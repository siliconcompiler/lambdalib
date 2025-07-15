from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Aoi221(DesignSchema):
    def __init__(self):
        name = 'la_aoi221'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Aoi221()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
