from lambdalib import stdlib
from lambdalib import auxlib
from lambdalib import ramlib
from lambdalib import vectorlib
from lambdalib import iolib
from lambdalib import fpgalib


def test_class_stdlib():
    for name in stdlib.__all__:
        obj = getattr(stdlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_auxlib():
    for name in auxlib.__all__:
        obj = getattr(auxlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_ramlib():
    for name in ramlib.__all__:
        obj = getattr(ramlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_vectorlib():
    for name in vectorlib.__all__:
        obj = getattr(vectorlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_iolib():
    for name in iolib.__all__:
        obj = getattr(iolib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_fpgalib():
    for name in fpgalib.__all__:
        obj = getattr(fpgalib, name)
        instance = obj()
        assert instance.check_filepaths()
