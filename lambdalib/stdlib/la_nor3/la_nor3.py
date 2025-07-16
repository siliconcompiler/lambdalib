from siliconcompiler import DesignSchema
from lambdalib import Lambda

class nor3(Lambda):
    def __init__(self):
        name = 'la_nor3'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = nor3()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
