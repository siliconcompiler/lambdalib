from siliconcompiler import DesignSchema
from lambdalib import Lambda

class ao222(Lambda):
    def __init__(self):
        name = 'la_ao222'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = ao222()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
