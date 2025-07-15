from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup


class iovdda(DesignSchema):
    def __init__(self):
        name = 'la_iovdda'
        super().__init__(name)
        basic_setup(self, __file__, name)


if __name__ == "__main__":
    d = iovdda()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
