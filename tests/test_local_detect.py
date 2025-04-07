from siliconcompiler import Chip
import lambdalib._common


def test_local_install_detection():
    chip = Chip('<test>')
    lambdalib._common.register_data_source(chip)
    assert 'git+https' not in chip.get('package', 'source', 'lambdalib', 'path')
