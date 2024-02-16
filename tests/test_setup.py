import pytest
from siliconcompiler import Chip

import lambdalib


@pytest.mark.parametrize('lib', lambdalib._libraries)
def test_setup(lib):
    chip = Chip('<lib>')
    chip.use(lambdalib)

    lib_name = f'la_{lib}'

    assert lib_name in chip.getkeys('library')
    assert len(chip.get('library', lib_name, 'option', 'ydir')) == 1


@pytest.mark.parametrize(
        'lib,has_idir',
        [(lib, lib == 'padring') for lib in lambdalib._libraries])
def test_setup_with_idir(lib, has_idir):
    chip = Chip('<lib>')
    chip.use(lambdalib)

    lib_name = f'la_{lib}'
    assert lib_name in chip.getkeys('library')

    excpect_idir = 0
    if has_idir:
        excpect_idir = 1

    assert len(chip.get('library', lib_name, 'option', 'idir')) == excpect_idir
