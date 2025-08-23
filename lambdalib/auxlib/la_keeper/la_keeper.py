from lambdalib.lambdalib import Lambda


class Keeper(Lambda):
    def __init__(self):
        name = 'la_keeper'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Keeper()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
