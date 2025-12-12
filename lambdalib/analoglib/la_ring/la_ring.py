from lambdalib.lambdalib import Lambda


class PLL(Lambda):
    def __init__(self):
        name = 'la_pll'
        super().__init__(name, __file__)


if __name__ == "__main__":
    d = PLL()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
