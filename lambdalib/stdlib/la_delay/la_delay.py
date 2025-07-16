from siliconcompiler import DesignSchema
from lambdalib import Lambda

class delay(Lambda):
    def __init__(self):
        name = 'la_delay'
        sources = [f'rtl/{name}.v']
        super().__init__(name, sources, __file__)

if __name__ == "__main__":
    d = delay()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
