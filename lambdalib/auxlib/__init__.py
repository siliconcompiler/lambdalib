from siliconcompiler import Design

# TODO: circular dependency, needs fixing
from .la_drsync.la_drsync import Drsync
from .la_dsync.la_dsync import Dsync

from .la_antenna.la_antenna import Antenna
from .la_clkdiv2.la_clkdiv2 import Clkdiv2
from .la_clkicgand.la_clkicgand import Clkicgand
from .la_clkicgor.la_clkicgor import Clkicgor
from .la_clkmux2.la_clkmux2 import Clkmux2
from .la_clkmux4.la_clkmux4 import Clkmux4
from .la_decap.la_decap import Decap
from .la_footer.la_footer import Footer
from .la_header.la_header import Header
from .la_ibuf.la_ibuf import Ibuf
from .la_iddr.la_iddr import Iddr
from .la_idiff.la_idiff import Idiff
from .la_isohi.la_isohi import Isohi
from .la_isolo.la_isolo import Isolo
from .la_keeper.la_keeper import Keeper
from .la_obuf.la_obuf import Obuf
from .la_oddr.la_oddr import Oddr
from .la_odiff.la_odiff import Odiff
from .la_pwrbuf.la_pwrbuf import Pwrbuf
from .la_rsync.la_rsync import Rsync
from .la_tbuf.la_tbuf import Tbuf

__all__ = ['Antenna',
           'Clkdiv2',
           'Clkicgand',
           'Clkicgor',
           'Clkmux2',
           'Clkmux4',
           'Decap',
           'Drsync',
           'Dsync',
           'Footer',
           'Header',
           'Ibuf',
           'Iddr',
           'Idiff',
           'Isohi',
           'Isolo',
           'Keeper',
           'Obuf',
           'Oddr',
           'Odiff',
           'Pwrbuf',
           'Rsync',
           'Tbuf']


class AUXLib(Design):
    def __init__(self):
        super().__init__("la_auxlib")

        with self.active_fileset("rtl"):
            self.add_depfileset(Antenna(), depfileset="rtl")
            self.add_depfileset(Clkdiv2(), depfileset="rtl")
            self.add_depfileset(Clkicgand(), depfileset="rtl")
            self.add_depfileset(Clkicgor(), depfileset="rtl")
            self.add_depfileset(Clkmux2(), depfileset="rtl")
            self.add_depfileset(Clkmux4(), depfileset="rtl")
            self.add_depfileset(Decap(), depfileset="rtl")
            self.add_depfileset(Drsync(), depfileset="rtl")
            self.add_depfileset(Dsync(), depfileset="rtl")
            self.add_depfileset(Footer(), depfileset="rtl")
            self.add_depfileset(Header(), depfileset="rtl")
            self.add_depfileset(Ibuf(), depfileset="rtl")
            self.add_depfileset(Iddr(), depfileset="rtl")
            self.add_depfileset(Idiff(), depfileset="rtl")
            self.add_depfileset(Isohi(), depfileset="rtl")
            self.add_depfileset(Isolo(), depfileset="rtl")
            self.add_depfileset(Keeper(), depfileset="rtl")
            self.add_depfileset(Obuf(), depfileset="rtl")
            self.add_depfileset(Oddr(), depfileset="rtl")
            self.add_depfileset(Odiff(), depfileset="rtl")
            self.add_depfileset(Pwrbuf(), depfileset="rtl")
            self.add_depfileset(Rsync(), depfileset="rtl")
            self.add_depfileset(Tbuf(), depfileset="rtl")
