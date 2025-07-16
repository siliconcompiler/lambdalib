from siliconcompiler import DesignSchema
from lambdalib import Lambda

class rsync(Lambda):
    def __init__(self):
        name = 'la_rsync'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = rsync()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
