from siliconcompiler import DesignSchema
from lambdalib import Lambda

class clkor2(Lambda):
    def __init__(self):
        name = 'la_clkor2'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = clkor2()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
