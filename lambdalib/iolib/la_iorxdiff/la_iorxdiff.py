from lambdalib.lambdalib import Lambda


class Iorxdiff(Lambda):
    def __init__(self):
        name = 'la_iorxdiff'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Iorxdiff()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
