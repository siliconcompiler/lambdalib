from typing import List, Union
from pathlib import Path
from siliconcompiler import DesignSchema


class Lambda(DesignSchema):

    def __init__(self,
                 name: str,
                 sources: List[str],
                 path: Union[str, Path]):

        super().__init__(name)

        fileset = 'rtl'
        dataroot = f'{name}'
        topmodule = f'la_{name}'

        self.set_dataroot(dataroot, path)
        self.set_topmodule(topmodule, fileset)

        for item in sources:
            self.add_file(item, fileset, dataroot=dataroot)
