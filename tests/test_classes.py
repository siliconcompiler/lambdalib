from lambdalib import auxlib
from lambdalib import iolib

def test_class_auxlib():
    for name in auxlib.__all__:
        obj = getattr(auxlib, name)
        instance = obj()
        assert instance.check_filepaths()

def test_class_iolib():
    for name in iolib.__all__:
        obj = getattr(iolib, name)
        instance = obj()
        assert instance.check_filepaths()
