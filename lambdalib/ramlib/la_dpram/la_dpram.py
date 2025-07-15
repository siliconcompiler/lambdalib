from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class La_dpram(DesignSchema):
    def __init__(self):

        name = 'la_dpram'
        topmodule = 'la_dpram'
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
    d = La_dpram()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
