from lambdalib.lambdalib import Lambda


class Footer(Lambda):
    def __init__(self):
        name = 'la_footer'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = Footer()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
