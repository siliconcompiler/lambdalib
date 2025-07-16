from siliconcompiler import DesignSchema
from lambdalib import Lambda

class xnor4(Lambda):
    def __init__(self):
        name = 'la_xnor4'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = xnor4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
