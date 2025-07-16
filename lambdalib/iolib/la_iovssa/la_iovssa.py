from siliconcompiler import DesignSchema
from lambdalib import Lambda

class iovssa(Lambda):
    def __init__(self):
        name = 'la_iovssa'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = iovssa()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
