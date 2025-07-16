from siliconcompiler import DesignSchema
from lambdalib import Lambda

class ble4p0(Lambda):
    def __init__(self):
        name = 'la_ble4p0'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = ble4p0()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
