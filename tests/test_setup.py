from siliconcompiler import Chip

import lambdalib


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

    assert len(chip.get('library', 'la_ramlib', 'option', 'ydir')) == 2


def test_setup_with_idir():
    chip = Chip('<lib>')
    chip.use(lambdalib)

    assert 'la_padring' in chip.getkeys('library')

    assert len(chip.get('library', 'la_padring', 'option', 'idir')) == 1
