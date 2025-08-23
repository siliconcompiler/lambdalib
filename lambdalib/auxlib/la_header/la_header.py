from lambdalib.lambdalib import Lambda


class Header(Lambda):
    def __init__(self):
        name = 'la_header'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Header()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
