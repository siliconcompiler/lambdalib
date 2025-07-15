from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup


class muxi3(DesignSchema):
    def __init__(self):
        name = 'la_muxi3'
        super().__init__(name)
        basic_setup(self, __file__, name)


if __name__ == "__main__":
    d = muxi3()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
