from siliconcompiler import Chip

from lambdalib import lambdalib


def test_pdk_paths():
    chip = Chip('<lib>')
    chip.use(lambdalib)
    assert chip.check_filepaths()
