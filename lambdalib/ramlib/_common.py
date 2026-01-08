import os.path

from collections import OrderedDict
from jinja2 import Template
from pathlib import Path

from typing import Union, Optional, List, Type, TYPE_CHECKING

from lambdalib.lambdalib import Lambda

if TYPE_CHECKING:
    from lambdalib.ramlib import RAMTechLib


class RAMLib(Lambda):
    def __init__(self, name: str, path: Union[str, Path],
                 impl_file: Optional[Union[str, Path]] = None):
        super().__init__(name, path)

        if impl_file:
            with self.active_dataroot(name), self.active_fileset("rtl.impl"):
                self.add_file(impl_file)
            with self.active_fileset("rtl"):
                self.add_depfileset(self, "rtl.impl")

    def write_lambdalib(self, path: Union[str, Path],
                        memories: List[Type["RAMTechLib"]],
                        min_size: Optional[int] = None) -> None:
        """Writes a fileset file listing the RTL files for this lambda library.

        Args:
            path: The path to the output fileset file.
            memories: A list of memory classes.
            min_size: An optional minimum size for the memories.

        Example:
            >>> lib.write_lambdalib("output.v", lambda_memories.techlibs)
        """
        template_path = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                                 'templates',
                                                 f'{self.name}memory.v'))

        memdata = {}
        for mem in memories:
            memobj = mem()
            memdata[memobj.get_ram_libcell()] = {
                "DW": memobj.get_ram_width(),
                "AW": memobj.get_ram_depth(),
                "port_map": [(port, wire) for port, wire in memobj.get_ram_ports().items()]
            }

        widths_table = []
        depths_table = []
        memory_port_map = {}
        selection_table = {}
        memory_inst_map = {}

        if min_size is None:
            min_size = 0

        for memory, info in sorted(memdata.items(), key=lambda mem: mem[0]):
            widths_table.append(
                (memory, info['DW'])
            )
            depths_table.append(
                (memory, info['AW'])
            )

            memory_port_map[memory] = sorted(info["port_map"])
            memory_inst_map[memory] = memory

            selection_table.setdefault(info['AW'], {})[int(info['DW'])] = memory

        selection_table = OrderedDict(sorted(selection_table.items(), reverse=True))
        for aw, items in selection_table.items():
            selection_table[aw] = OrderedDict(sorted(items.items(), reverse=True))

        widths_table.sort()
        depths_table.sort()

        with open(template_path) as f:
            template = Template(f.read())

        with open(path, 'w') as fout:
            fout.write(template.render(
                type=self.name,
                width_table=widths_table,
                depth_table=depths_table,
                selection_table=selection_table,
                inst_map=memory_inst_map,
                port_mapping=memory_port_map,
                minsize=min_size))
