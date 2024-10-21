import pytest
from siliconcompiler import Chip

from lambdalib import \
    auxlib, \
    fpgalib, \
    iolib, \
    padring, \
    ramlib, \
    stdlib, \
    vectorlib
libraries = [
    auxlib,
    fpgalib,
    iolib,
    padring,
    ramlib,
    stdlib,
    vectorlib
]


@pytest.mark.parametrize('lib', libraries)
def test_setup(lib):
    chip = Chip('<lib>')
    chip.use(lib)

    lib_name = lib.__name__.replace('.', '_')

    assert lib_name in chip.getkeys('library')
    assert len(chip.get('library', lib_name, 'option', 'ydir')) == 1


@pytest.mark.parametrize(
        'lib,has_idir',
        [(lib, lib == padring) for lib in libraries])
def test_setup_with_idir(lib, has_idir):
    chip = Chip('<lib>')
    chip.use(lib)

    lib_name = lib.__name__.replace('.', '_')

    assert lib_name in chip.getkeys('library')

    excpect_idir = 0
    if has_idir:
        excpect_idir = 1

    assert len(chip.get('library', lib_name, 'option', 'idir')) == excpect_idir
