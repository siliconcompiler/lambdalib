from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Dffrqn(DesignSchema):
    def __init__(self):
        name = 'la_dffrqn'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Dffrqn()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
