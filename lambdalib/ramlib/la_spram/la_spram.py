from siliconcompiler import DesignSchema
from lambdalib import Lambda

class spram(Lambda):
    def __init__(self):
        name = 'la_spram'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = spram()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
