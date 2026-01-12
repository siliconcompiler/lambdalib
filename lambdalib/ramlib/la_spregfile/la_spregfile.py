from lambdalib.ramlib._common import RAMLib


class Spregfile(RAMLib):
    def __init__(self):
        name = 'la_spregfile'
        super().__init__(name, __file__, impl_file='rtl/la_spregfile_impl.v')


if __name__ == "__main__":
    d = Spregfile()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
