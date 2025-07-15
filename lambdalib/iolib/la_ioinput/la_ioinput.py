from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Ioinput(DesignSchema):
    def __init__(self):
        name = 'la_ioinput'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Ioinput()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
