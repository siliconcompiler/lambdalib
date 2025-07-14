from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Decap(DesignSchema):
    def __init__(self):

        name = 'la_decap'
        topmodule = 'la_decap'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_datadir(root, __file__)

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, datadir=root)

        # top module
        self.set_topmodule(topmodule, fileset)


if __name__ == "__main__":
    d = Decap()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
