from .la_antenna.la_antenna import Antenna
from .la_clkicgand.la_clkicgand import Clkicgand
from .la_clkicgor.la_clkicgor import Clkicgor
from .la_clkmux2.la_clkmux2 import Clkmux2
from .la_clkmux4.la_clkmux4 import Clkmux4
from .la_decap.la_decap import Decap
from .la_drsync.la_drsync import Drsync
from .la_dsync.la_dsync import Dsync
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
           'Idiff',
           'Pwrbuf',
           'Rsync',
           'Ttbuf']

########################################
# Old SiliconCompiler Setup (deprecated)
########################################

from siliconcompiler import Library
from lambdalib._common import register_data_source
from lambdalib import stdlib

def setup():
    '''
    Lambdalib auxlib
    '''

    lib = Library('lambdalib_auxlib', package='lambdalib', auto_enable=True)
    register_data_source(lib)

    cells = ['la_antenna',
             'la_clkicgand',
             'la_clkicgor',
             'la_clkmux2',
             'la_clkmux4',
             'la_decap',
             'la_drsync',
             'la_dsync',
             'la_footer',
             'la_header',
             'la_ibuf',
             'la_iddr',
             'la_idiff',
             'la_isohi',
             'la_isolo',
             'la_keeper',
             'la_obuf',
             'la_oddr',
             'la_odiff',
             'la_pwrbuf',
             'la_rsync',
             'la_tbuf']

    for item in cells:
        lib.input(f'{item}/rtl/{item}.v')

    lib.use(stdlib)

    return lib
