from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Clkmux4(DesignSchema):
    def __init__(self):

        name = 'la_clkmux4'
        topmodule = 'la_clkmux4'
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
    d = Clkmux4()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
