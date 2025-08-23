from lambdalib.lambdalib import Lambda


class Ioanalog(Lambda):
    def __init__(self):
        name = 'la_ioanalog'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Ioanalog()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
