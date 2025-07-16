from siliconcompiler import DesignSchema
from lambdalib import Lambda

class clkbuf(Lambda):
    def __init__(self):
        name = 'la_clkbuf'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = clkbuf()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
