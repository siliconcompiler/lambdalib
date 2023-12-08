import os
import pkg_resources
try:
    __version__ = pkg_resources.get_distribution('lambdalib').version
except:  # noqa E722
    __version__ = None


def register_data_source(chip):
    # check if local
    root_path = os.path.dirname(os.path.dirname(__file__))
    test_path = os.path.join(root_path, 'lambdalib', 'iolib', 'rtl', 'la_ioanalog.v')
    if os.path.exists(test_path):
        path = root_path
        ref = None
    else:
        path = 'git+https://github.com/siliconcompiler/lambdalib.git'
        ref = f'v{__version__}'

    chip.register_package_source(name='lambdalib',
                                 path=path,
                                 ref=ref)
