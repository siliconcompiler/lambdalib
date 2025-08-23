from siliconcompiler import Chip
import pytest
import lambdalib

pytestmark = pytest.mark.skip(reason="Skipping until SC update finished")


def test_pdk_paths():
    chip = Chip('<lib>')
    chip.use(lambdalib)
    assert chip.check_filepaths()
