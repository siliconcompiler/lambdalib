import pytest

import lambdalib as ll


@pytest.mark.parametrize("name", ll.analoglib.__all__)
def test_lint_analoglib(name):
    assert getattr(ll.analoglib, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.auxlib.__all__)
def test_lint_auxlib(name):
    assert getattr(ll.auxlib, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.ramlib.__all__)
def test_lint_ramlib(name):
    assert getattr(ll.ramlib, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.veclib.__all__)
def test_lint_veclib(name):
    assert getattr(ll.veclib, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.iolib.__all__)
def test_lint_iolib(name):
    assert getattr(ll.iolib, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.padring.__all__)
def test_lint_padring(name):
    assert getattr(ll.padring, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.fpgalib.__all__)
def test_lint_fpgalib(name):
    assert getattr(ll.fpgalib, name)().check_filepaths()


@pytest.mark.parametrize("name", ll.stdlib.__all__)
def test_lint_stdlib(name):
    assert getattr(ll.stdlib, name)().check_filepaths()
