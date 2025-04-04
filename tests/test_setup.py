import pytest
from siliconcompiler import Chip


@pytest.fixture(params=(1, 2, 3, 4, 5, 6, 7))
def lib(request):
    from lambdalib import \
        auxlib, \
        fpgalib, \
        iolib, \
        padring, \
        ramlib, \
        stdlib, \
        vectorlib

    if request.param == 1:
        return auxlib
    if request.param == 2:
        return fpgalib
    if request.param == 3:
        return iolib
    if request.param == 4:
        return padring
    if request.param == 5:
        return ramlib
    if request.param == 6:
        return stdlib
    if request.param == 7:
        return vectorlib


def test_setup(lib):
    chip = Chip('<lib>')
    chip.use(lib)

    lib_name = lib.__name__.replace('.', '_')

    assert lib_name in chip.getkeys('library')
    assert len(chip.get('library', lib_name, 'option', 'ydir')) == 1


def test_setup_with_idir(lib):
    from lambdalib import padring
    chip = Chip('<lib>')
    chip.use(lib)

    lib_name = lib.__name__.replace('.', '_')

    assert lib_name in chip.getkeys('library')

    excpect_idir = 0
    if lib == padring:
        excpect_idir = 1

    assert len(chip.get('library', lib_name, 'option', 'idir')) == excpect_idir
