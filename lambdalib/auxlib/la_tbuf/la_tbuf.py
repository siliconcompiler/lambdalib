from siliconcompiler import DesignSchema
from lambdalib import Lambda

class tbuf(Lambda):
    def __init__(self):
        name = 'la_tbuf'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = tbuf()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
