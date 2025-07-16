from siliconcompiler import DesignSchema
from lambdalib import Lambda

class oddr(Lambda):
    def __init__(self):
        name = 'la_oddr'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = oddr()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
