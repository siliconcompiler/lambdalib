from lambdalib.lambdalib import Lambda


class Rsync(Lambda):
    def __init__(self):
        name = 'la_rsync'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Rsync()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
