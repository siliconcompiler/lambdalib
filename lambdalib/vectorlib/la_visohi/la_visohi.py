from siliconcompiler import DesignSchema
from lambdalib import Lambda

class visohi(Lambda):
    def __init__(self):
        name = 'la_visohi'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = visohi()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
