from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class isolo(DesignSchema):
    def __init__(self):
        name = 'la_isolo'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = isolo()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
