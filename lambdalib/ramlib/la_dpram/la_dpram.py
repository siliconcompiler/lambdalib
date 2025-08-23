from lambdalib.lambdalib import Lambda


class Dpram(Lambda):
    def __init__(self):
        name = 'la_dpram'
        super().__init__(name, __file__, extrasources=['rtl/la_dpram_impl.v'])


if __name__ == "__main__":
    d = Dpram()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
