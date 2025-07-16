from siliconcompiler import DesignSchema
from lambdalib import Lambda

class and3(Lambda):
    def __init__(self):
        name = 'la_and3'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = and3()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
