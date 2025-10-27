from lambdalib.ramlib._common import _RAMLib


class Tdpram(_RAMLib):
    def __init__(self):
        name = 'la_tdpram'
        super().__init__(name, __file__, impl_file='rtl/la_tdpram_impl.v')


if __name__ == "__main__":
    d = Tdpram()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
