from lambdalib.lambdalib import Lambda


class Spram(Lambda):
    def __init__(self):
        name = 'la_spram'
        super().__init__(name, __file__, extrasources=['rtl/la_spram_impl.v'])


if __name__ == "__main__":
    d = Spram()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
