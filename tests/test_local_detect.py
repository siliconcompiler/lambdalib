from siliconcompiler import Chip
from lambdalib._common import register_data_source


def test_local_install_detection():
    chip = Chip('<test>')
    register_data_source(chip)
    assert 'git+https' not in chip.get('package', 'source', 'lambdalib', 'path')
