from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class La_spram(DesignSchema):
    def __init__(self):

        name = 'la_spram'
        topmodule = 'la_spram'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_package(root, __file__)

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, package=root)

        # top module
        self.set_topmodule(topmodule, fileset)


if __name__ == "__main__":
    d = La_spram()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
