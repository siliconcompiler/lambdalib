from siliconcompiler import DesignSchema
from lambdalib import Lambda

class aoi31(Lambda):
    def __init__(self):
        name = 'la_aoi31'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = aoi31()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
