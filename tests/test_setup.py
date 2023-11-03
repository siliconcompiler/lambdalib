from siliconcompiler import Chip

from lambdalib import lambdalib


def test_setup_without_depencency():
    chip = Chip('<lib>')
    chip.use(lambdalib)

    assert 'la_stdlib' in chip.getkeys('library')

    assert len(chip.get('library', 'la_stdlib', 'option', 'ydir')) == 1


def test_setup_with_depencency():
    chip = Chip('<lib>')
    chip.use(lambdalib)

    assert 'la_stdlib' in chip.getkeys('library')
    assert 'la_iolib' in chip.getkeys('library')
    assert 'la_ramlib' in chip.getkeys('library')

    assert len(chip.get('library', 'la_iolib', 'option', 'ydir')) == 2
    assert len(chip.get('library', 'la_ramlib', 'option', 'ydir')) == 2
