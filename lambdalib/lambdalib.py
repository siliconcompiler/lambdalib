from pathlib import Path
from typing import Union, List
from siliconcompiler import Design


class Lambda(Design):
    def __init__(self,
                 name: str,
                 path: Union[str, Path],
                 extrasources: List[str] = None):

        super().__init__(name)

        self.set_dataroot(name, path)

        with self.active_fileset("rtl"):
            self.set_topmodule(name)

            with self.active_dataroot(name):
                self.add_file(f"rtl/{name}.v")

                if extrasources:
                    self.add_file(extrasources)
