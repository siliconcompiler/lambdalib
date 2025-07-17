import subprocess
import lambdalib as ll

def lint(design):
    script = f"{design.name()}.f"
    design.write_fileset(script, fileset="rtl")
    cmd = ['slang', '-f', script]
    return subprocess.run(cmd,
                          stderr=subprocess.STDOUT,
                          check=True)

def test_lint_stdlib():
    for name in ll.stdlib.__all__:
        design = getattr(ll.stdlib, name)
        assert lint(design())

def test_lint_auxlib():
    for name in ll.auxlib.__all__:
        design = getattr(ll.auxlib, name)
        assert lint(design())

def test_lint_ramlib():
    for name in ll.ramlib.__all__:
        design = getattr(ll.ramlib, name)
        assert lint(design())

def test_lint_vectorlib():
    for name in ll.vectorlib.__all__:
        design = getattr(ll.vectorlib, name)
        assert lint(design())

def test_lint_iolib():
    for name in ll.iolib.__all__:
        design = getattr(ll.iolib, name)
        assert lint(design())

def test_lint_padring():
    for name in ll.padring.__all__:
        design = getattr(ll.padring, name)
        assert lint(design())

def test_lint_fpgalib():
    for name in ll.fpgalib.__all__:
        design = getattr(ll.fpgalib, name)
        assert lint(design())
