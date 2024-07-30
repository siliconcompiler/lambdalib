import siliconcompiler.package as sc_package


_version = "0.2.8"


def register_data_source(chip):
    sc_package.register_python_data_source(
        chip,
        "lambdalib",
        "lambdalib",
        "git+https://github.com/siliconcompiler/lambdalib.git",
        alternative_ref=f"v{_version}",
        python_module_path_append="..")
