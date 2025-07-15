from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup


class oa222(DesignSchema):
    def __init__(self):
        name = 'la_oa222'
        super().__init__(name)
        basic_setup(self, __file__, name)


if __name__ == "__main__":
    d = oa222()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
