from siliconcompiler import DesignSchema
from lambdalib._common import basic_setup

class Keeper(DesignSchema):
    def __init__(self):
        name = 'la_keeper'
        super().__init__(name)
        basic_setup(self, __file__, name)

if __name__ == "__main__":
    d = Keeper()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
