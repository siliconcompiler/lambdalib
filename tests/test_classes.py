import lambdalib as ll


def test_class_stdlib():
    for name in ll.stdlib.__all__:
        obj = getattr(ll.stdlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_auxlib():
    for name in ll.auxlib.__all__:
        obj = getattr(ll.auxlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_ramlib():
    for name in ll.ramlib.__all__:
        obj = getattr(ll.ramlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_vectorlib():
    for name in ll.vectorlib.__all__:
        obj = getattr(ll.vectorlib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_iolib():
    for name in ll.iolib.__all__:
        obj = getattr(ll.iolib, name)
        instance = obj()
        assert instance.check_filepaths()


def test_class_padring():
    for name in ll.padring.__all__:
        obj = getattr(ll.padring, name)
        instance = obj()
        assert instance.check_filepaths()

def test_class_fpgalib():
    for name in ll.fpgalib.__all__:
        obj = getattr(ll.fpgalib, name)
        instance = obj()
        assert instance.check_filepaths()
