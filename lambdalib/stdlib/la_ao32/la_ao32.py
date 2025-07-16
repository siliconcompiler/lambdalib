from siliconcompiler import DesignSchema
from lambdalib import Lambda

class ao32(Lambda):
    def __init__(self):
        name = 'la_ao32'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = ao32()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
