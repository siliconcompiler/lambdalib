import pytest

import lambdalib as ll
from siliconcompiler import Project
from siliconcompiler.flows import lintflow


def lint(design):
    proj = Project(design)
    proj.add_fileset("rtl")
    proj.set_flow(lintflow.LintFlow())
    proj.set('option', 'nodashboard', True)
    return proj.run()


@pytest.mark.parametrize("name", ll.stdlib.__all__)
def test_lint_stdlib(name):
    assert lint(getattr(ll.stdlib, name)())


@pytest.mark.parametrize("name", ll.auxlib.__all__)
def test_lint_auxlib(name):
    assert lint(getattr(ll.auxlib, name)())


@pytest.mark.parametrize("name", ll.ramlib.__all__)
def test_lint_ramlib(name):
    assert lint(getattr(ll.ramlib, name)())


@pytest.mark.parametrize("name", ll.veclib.__all__)
def test_lint_veclib(name):
    assert lint(getattr(ll.veclib, name)())


@pytest.mark.parametrize("name", ll.iolib.__all__)
def test_lint_iolib(name):
    assert lint(getattr(ll.iolib, name)())


@pytest.mark.parametrize("name", ll.padring.__all__)
def test_lint_padring(name):
    assert lint(getattr(ll.padring, name)())


@pytest.mark.parametrize("name", ll.fpgalib.__all__)
def test_lint_fpgalib(name):
    assert lint(getattr(ll.fpgalib, name)())
