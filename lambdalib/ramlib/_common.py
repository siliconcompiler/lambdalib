from pathlib import Path
from typing import Dict, Union, Optional, List, Tuple

from lambdalib.lambdalib import Lambda
from lambdalib.utils import write_la_ram


class _RAMLib(Lambda):
    def __init__(self, name: str, path: Union[str, Path],
                 impl_file: Optional[Union[str, Path]] = None):
        super().__init__(name, path)

        if impl_file:
            with self.active_dataroot(name), self.active_fileset("rtl.impl"):
                self.add_file(impl_file)
            with self.active_fileset("rtl"):
                self.add_depfileset(self, "rtl.impl")

    def write_lambdalib(self, path: Union[str, Path],
                        memories: Dict[str, Dict[str, Union[int, str, List[Tuple[str, str]]]]],
                        control_signals: List[str],
                        min_size: Optional[int] = None) -> None:
        """Writes a fileset file listing the RTL files for this lambda library.

        Args:
            path: The path to the output fileset file.
            memories: A dictionary of memory specifications.
            control_signals: A list of control signal declarations.
            min_size: An optional minimum size for the memories.

        Example:
            >>> memories = {
            ...     "fakeram45_64x32": {
            ...         "DW": 32,
            ...         "AW": 6,
            ...         "port_map": [
            ...             ("clk", "clk"),
            ...             ("addr_in", "mem_addr"),
            ...             ("ce_in", "ce_in"),
            ...             ("rd_out", "mem_dout"),
            ...             ("we_in", "we_in"),
            ...             ("w_mask_in", "mem_wmask"),
            ...             ("wd_in", "mem_din")
            ...         ]
            ...     },
            ...     "fakeram45_64x32_2": {
            ...         "DW": 64,
            ...         "AW": 8,
            ...         "port_map": [
            ...             ("clk0", "clk"),
            ...             ("csb0", "ce_in && we_in"),
            ...             ("web0", "ce_in && we_in"),
            ...             ("wmask0", "{mem_wmask[8], mem_wmask[0]}"),
            ...             ("addr0", "mem_addr"),
            ...             ("din0", "mem_din"),
            ...             ("dout0", ""),
            ...             ("clk1", "clk"),
            ...             ("csb1", "ce_in && ~we_in"),
            ...             ("addr1", "mem_addr"),
            ...             ("dout1", "mem_dout"),
            ...         ]
            ...     }
            ... }
            >>> control_signals = ["wire [3:0] extra_ctrl"]
            >>> lib.write_lambdalib("output.v", memories, control_signals)
        """
        with open(path, 'w') as f:
            write_la_ram(f, memories, control_signals, la_type=self.name, minsize=min_size)
