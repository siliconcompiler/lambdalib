from jinja2 import Template
import os
from collections import OrderedDict


def write_la_spram(fout, memories, control_signals=None, la_type='ram'):
    template_path = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                                 'templates',
                                                 'la_spmemory.v'))

    widths_table = []
    depths_table = []
    memory_port_map = {}
    selection_table = {}
    memory_inst_map = {}

    for memory, info in memories.items():
        widths_table.append(
            (memory, info['DW'])
        )
        depths_table.append(
            (memory, info['AW'])
        )

        memory_port_map[memory] = sorted(info["port_map"])
        if "inst_name" not in info:
            memory_inst_map[memory] = memory
        else:
            memory_inst_map[memory] = info["inst_name"]

        selection_table.setdefault(info['AW'], {})[int(info['DW'])] = memory

    selection_table = OrderedDict(sorted(selection_table.items(), reverse=True))
    for aw, items in selection_table.items():
        selection_table[aw] = OrderedDict(sorted(items.items(), reverse=True))
    widths_table.sort()
    depths_table.sort()

    with open(template_path) as f:
        template = Template(f.read())

    fout.write(template.render(
        type=la_type,
        width_table=widths_table,
        depth_table=depths_table,
        selection_table=selection_table,
        inst_map=memory_inst_map,
        port_mapping=memory_port_map,
        control_signals=control_signals))
