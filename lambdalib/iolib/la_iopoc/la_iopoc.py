from siliconcompiler import DesignSchema
from lambdalib import Lambda

class iopoc(Lambda):
    def __init__(self):
        name = 'la_iopoc'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = iopoc()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
