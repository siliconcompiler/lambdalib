import os
import glob
import shutil
from siliconcompiler import Chip
import siliconcompiler.package as sc_package


def register_data_source(chip):
    chip.register_source("lambdalib", "python://lambdalib")


# TODO: remove
def basic_setup(design, path, name):
    topmodule = name
    datadir_name = f'{name}_data'
    source = [f'rtl/{name}.v']

    # set data home directory
    design.register_dataref(datadir_name, path)

    # rtl files
    fileset = 'rtl'
    for item in source:
        design.add_file(item, fileset, dataref=datadir_name)

    # top module
    design.set_topmodule(topmodule, fileset)

########################
# SiliconCompiler Setup
########################


def __get_lambdalib_dir(la_lib):
    path_assert = Chip('lambdalib')
    register_data_source(path_assert)
    lambdalib_path = sc_package.path(path_assert, 'lambdalib')
    return f'{lambdalib_path}/{la_lib}/rtl'


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

    if la_lib == 'auxlib' and not extra_cells:
        # allow auxlib to have missing cells
        return True

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
    full_exclude = []
    if exclude:
        full_exclude.extend(exclude)

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

    copy(outputpath, la_lib, exclude)

    if isinstance(target, str):
        target = Chip("module")._load_module(target)

    target_name = target.__name__

    for cell in sorted(cells):
        cell_file = os.path.basename(cell)
        cell_name, _ = os.path.splitext(cell_file)

        chip = Chip(cell_name)
        chip.input(cell)
        chip.use(target)
        chip.set('asic', 'logiclib', logiclib)
        chip.set('option', 'flow', 'asicflow')
        chip.set('option', 'to', 'syn')
        chip.set('option', 'quiet', True)
        chip.set('option', 'jobname', f"{target_name}-{logiclib}")

        chip.set('tool', 'yosys', 'task', 'syn_asic', 'var', 'autoname', 'false')
        chip.set('tool', 'yosys', 'task', 'syn_asic', 'var', 'add_buffers', 'false')

        chip.add('option', 'ydir', outputpath)
        chip.run()

        result = chip.find_result("vg", step="syn", index=0)

        with open(os.path.join(outputpath, cell_file), 'w') as out:
            with open(cell, 'r') as org:
                for line in org:
                    out.write(f'// {line}')
                out.write(os.linesep)
            with open(result, 'r') as res:
                out.writelines(res.readlines())
