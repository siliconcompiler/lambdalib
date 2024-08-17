# Lambdalib Introduction

Lambdalib is a modular hardware abstraction library decouples design from the underlying manufacturing target. Lambdalib defines a set of generic functions that get resolved during the target technology mapping stage.

Lambdalib includes the following hardware categories:

| Category                            | Description                           |
|-------------------------------------|---------------------------------------|
|[stdlib](lambdalib/stdlib/rtl)       | Standard cells (inv, nand, ff, ...)
|[auxlib](lambdalib/auxlib/rtl)       | Aux cells can consist of multiple standard cells or physical only cells
|[ramlib](lambdalib/ramlib/rtl)       | Memory (single port, dual port, fifo, ...)
|[iolib](lambdalib/iolib)             | IO cells (bidir, vdd, clamp,...)
|[padring](lambdalib/padring)         | Padring generator
|[vectorlib](lambdalib/vectorlib/rtl) | Vectorized library (mux, isolation)
|[syslib](lambdalib/syslib/rtl)       | Vendor agnostic peripheral interface (uart, i2c,...)
|[fpgalib](lambdalib/fpgalib/rtl)     | FPGA cells (lut4, ble, clb)

The [Lambdapdk](https://github.com/siliconcompiler/lambdapdk) repository demonstrates implementation of the Lambdalib interfaces across a number of open source process technologies.

Lambdalib has successfully used in multiple tapeouts using [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler).

# License

[MIT](LICENSE)

# Issues / Bugs

We use [GitHub Issues](https://github.com/siliconcompiler/lambdalib/issues) for tracking requests and bugs.
