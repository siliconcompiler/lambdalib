from .la_antenna.la_antenna import antenna
from .la_clkicgand.la_clkicgand import clkicgand
from .la_clkicgor.la_clkicgor import clkicgor
from .la_clkmux2.la_clkmux2 import clkmux2
from .la_clkmux4.la_clkmux4 import clkmux4
from .la_decap.la_decap import decap
from .la_drsync.la_drsync import drsync
from .la_dsync.la_dsync import dsync
from .la_footer.la_footer import footer
from .la_header.la_header import header
from .la_ibuf.la_ibuf import ibuf
from .la_iddr.la_iddr import iddr
from .la_idiff.la_idiff import idiff
from .la_isohi.la_isohi import isohi
from .la_isolo.la_isolo import isolo
from .la_keeper.la_keeper import keeper
from .la_obuf.la_obuf import obuf
from .la_oddr.la_oddr import oddr
from .la_odiff.la_odiff import odiff
from .la_pwrbuf.la_pwrbuf import pwrbuf
from .la_rsync.la_rsync import rsync
from .la_tbuf.la_tbuf import tbuf

__all__ = ['antenna',
           'clkicgand',
           'clkicgor',
           'clkmux2',
           'clkmux4',
           'decap',
           'drsync',
           'dsync',
           'footer',
           'header',
           'ibuf',
           'iddr',
           'idiff',
           'isohi',
           'isolo',
           'keeper',
           'obuf',
           'ddr',
           'odiff',
           'pwrbuf',
           'rsync',
           'tbuf']

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
