from lambdalib.lambdalib import Lambda


class Tdpram(Lambda):
    def __init__(self):
        name = 'la_tdpram'
        super().__init__(name, __file__, extrasources=['rtl/la_tdpram_impl.v'])


if __name__ == "__main__":
    d = Tdpram()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
