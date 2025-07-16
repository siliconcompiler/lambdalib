from siliconcompiler import DesignSchema
from lambdalib import Lambda

class inv(Lambda):
    def __init__(self):
        name = 'la_inv'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = inv()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
