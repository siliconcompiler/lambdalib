_version = "0.3.4"

def basic_setup(design, path, name):
    topmodule = name
    datadir_name = f'{name}_data'
    source = [f'rtl/{name}.v']

    # set data home directory
    design.register_dataref(datadir_name, path)

    # rtl files
    fileset = 'rtl'
    for item in source:
        design.add_file(item, fileset, dataref=datadir_name)

    # top module
    design.set_topmodule(topmodule, fileset)
