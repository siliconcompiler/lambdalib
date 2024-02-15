from siliconcompiler import Chip
from siliconcompiler.package import path as sc_package
import glob
import os
import shutil
__version__ = "0.1.3"


def register_data_source(chip):
    # check if local
    root_path = os.path.dirname(os.path.dirname(__file__))
    test_path = os.path.join(root_path, 'lambdalib', 'iolib', 'rtl', 'la_ioanalog.v')
    if os.path.exists(test_path):
        path = root_path
        ref = None
    else:
        path = 'git+https://github.com/siliconcompiler/lambdalib.git'
        ref = f'v{__version__}'

    chip.register_package_source(name='lambdalib',
                                 path=path,
                                 ref=ref)


def __get_lambdalib_dir(la_lib):
    path_assert = Chip('lambdalib')
    register_data_source(path_assert)
    lambdalib_path = sc_package(path_assert, 'lambdalib')
    return f'{lambdalib_path}/lambdalib/{la_lib}/rtl'


def check(outputpath, la_lib='stdlib'):
    cells_dir = __get_lambdalib_dir(la_lib)

    lambda_cells = set()
    for cell in glob.glob(f'{cells_dir}/la_*.v'):
        lambda_cells.add(os.path.basename(cell))

    lib_cells = set()
    for cell in glob.glob(f'{outputpath}/la_*.v'):
        lib_cells.add(os.path.basename(cell))

    if lambda_cells == lib_cells:
        return True

    missing_cells = lambda_cells - lib_cells
    extra_cells = lib_cells - lambda_cells

    if missing_cells:
        for cell in missing_cells:
            print(f'Missing: {cell}')
    if extra_cells:
        for cell in extra_cells:
            print(f'Excess cell: {cell}')

    return False


def copy(outputpath, la_lib='stdlib', exclude=None):
    cells_dir = __get_lambdalib_dir(la_lib)

    if not exclude:
        exclude = []

    os.makedirs(outputpath, exist_ok=True)

    # Generate list of cells to produce
    for cell in glob.glob(f'{cells_dir}/la_*.v'):
        cell_file = os.path.basename(cell)
        cell_name, _ = os.path.splitext(cell_file)

        if cell_name in exclude:
            continue

        shutil.copy(cell, os.path.join(outputpath, cell_file))


def generate(target, logiclib, outputpath, la_lib='stdlib', exclude=None):
    exclude_default = (
        'la_decap',
        'la_keeper',
        'la_footer',
        'la_header',
        'la_antenna'
    )

    full_exclude = []
    if exclude:
        full_exclude.extend(exclude)

    full_exclude.extend(exclude_default)

    # Ensure files are loaded
    cells_dir = __get_lambdalib_dir(la_lib)

    # Generate list of cells to produce
    org_cells = set()
    cells = []
    for cell in glob.glob(f'{cells_dir}/la_*.v'):
        cell_name, _ = os.path.splitext(os.path.basename(cell))

        if cell_name in full_exclude:
            continue

        cells.append(cell)
        org_cells.add(cell_name)

    # Remove old implementations
    for cell in cells:
        new_path = os.path.join(outputpath, os.path.basename(cell))
        try:
            os.remove(new_path)
        except FileNotFoundError:
            pass

    os.makedirs(outputpath, exist_ok=True)

    if isinstance(target, str):
        target_name = target
    else:
        target_name = target.__name__

    for cell in cells:
        cell_file = os.path.basename(cell)
        cell_name, _ = os.path.splitext(cell_file)

        chip = Chip(cell_name)
        chip.input(cell)
        chip.load_target(target)
        chip.set('asic', 'logiclib', logiclib)
        chip.set('option', 'flow', 'asicflow')
        chip.set('option', 'to', 'syn')
        chip.set('option', 'quiet', True)
        chip.set('option', 'resume', True)
        chip.set('option', 'jobname', f"{target_name}-{logiclib}")

        chip.add('option', 'ydir', cells_dir)
        chip.run()

        result = chip.find_result("vg", step="syn", index=0)
        shutil.copy(result, os.path.join(outputpath, cell_file))

    if exclude:
        org_cells.update(exclude)
    copy(outputpath, la_lib, org_cells)
