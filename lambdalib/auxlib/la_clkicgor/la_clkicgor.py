from siliconcompiler import DesignSchema
from lambdalib import Lambda

class clkicgor(Lambda):
    def __init__(self):
        name = 'la_clkicgor'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = clkicgor()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
