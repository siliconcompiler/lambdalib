from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class ble4p0(DesignSchema):
    def __init__(self):
        name = 'la_ble4p0'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = ble4p0()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
