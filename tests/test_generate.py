import os
import pytest
import lambdalib

pytestmark = pytest.mark.skip(reason="Skipping until SC update finished")


def test_check():
    lambdalib.copy('./lambda')
    assert lambdalib.check('./lambda')


def test_check_missing_file():
    lambdalib.copy('./lambda', exclude=('la_and3',))
    assert not lambdalib.check('./lambda')


def test_check_extra_file():
    lambdalib.copy('./lambda')
    with open('./lambda/la_testing_cells.v', 'w') as f:
        f.write('test')
    assert not lambdalib.check('./lambda')


def test_check_missing_file_auxlib():
    lambdalib.copy('./lambda', la_lib='auxlib', exclude=('la_clkmux4',))
    assert lambdalib.check('./lambda', la_lib='auxlib')


def test_check_all_files_auxlib():
    lambdalib.copy('./lambda', la_lib='auxlib')
    assert lambdalib.check('./lambda', la_lib='auxlib')


def test_copy():
    lambdalib.copy('./lambda')

    assert os.path.exists('./lambda/la_and2.v')


def test_copy_with_exclude():
    lambdalib.copy('./lambda', exclude=('la_and3',))

    assert os.path.exists('./lambda/la_and2.v')
    assert not os.path.exists('./lambda/la_and3.v')
