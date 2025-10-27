from pathlib import Path
from typing import Union, Optional

from lambdalib.lambdalib import Lambda


class _RAMLib(Lambda):
    def __init__(self, name: str, path: Union[str, Path],
                 impl_file: Optional[Union[str, Path]] = None):
        super().__init__(name, path)

        if impl_file:
            with self.active_dataroot(name), self.active_fileset("rtl.impl"):
                self.add_file(impl_file)
            with self.active_fileset("rtl"):
                self.add_depfileset(self, "rtl.impl")
