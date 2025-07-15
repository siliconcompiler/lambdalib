from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Dffsq(DesignSchema):
    def __init__(self):
        name = 'la_dffsq'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Dffsq()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
