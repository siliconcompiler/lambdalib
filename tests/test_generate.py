import os
import lambdalib


def test_check():
    lambdalib.copy('./lambda')
    assert lambdalib.check('./lambda')


def test_check_missing_file():
    lambdalib.copy('./lambda', exclude=('la_and3',))
    assert not lambdalib.check('./lambda')


def test_copy():
    lambdalib.copy('./lambda')

    assert os.path.exists('./lambda/la_and2.v')


def test_copy_with_exclude():
    lambdalib.copy('./lambda', exclude=('la_and3',))

    assert os.path.exists('./lambda/la_and2.v')
    assert not os.path.exists('./lambda/la_and3.v')
