from siliconcompiler import DesignSchema
from lambdalib import Lambda

class dmux4(Lambda):
    def __init__(self):
        name = 'la_dmux4'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = dmux4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
