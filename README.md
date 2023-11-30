# lambdalib

# Introduction

Lambdalib is a modular a hardware abstraction layer that helps decouple hardware design from manufacturing technology and vendor proprietary IP interfaces. Lambdalib defines a set of standardized interfaces that are used to instantiate cells within a design. Technology specific modules that conform to the Lambdalib interfaces are linked at compiler time.

Lambdalib includes the following hardware categories:

| Category                  | Description|
|---------------------------|------------|
|[stdlib](stdlib/rtl)       | Standard cells (inv, nand, ff, ...)
|[ramlib](ramlib/rtl)       | Memory (single port, dual port, fifo, ...)
|[iolib](iolib/rtl)         | IO cells (bidir, vdd, clamp,...)
|[padring](padring/rtl)     | Padring generator
|[vectorlib](vectorlib/rtl) | Vectorized helper library (mux, isolation)
|[syslib](syslib/rtl)       | Vendor agnostic peripheral interface(uart, i2c,...)

The [lambdapdk](https://github.com/siliconcompiler/lambdapdk) repository demonstrates implementation of the lambdalib interfaces across a number of open source process technologies.

# License

[MIT](LICENSE)
# Issues / Bugs

We use [GitHub Issues](https://github.com/siliconcompiler/lambdalib/issues)
for tracking requests and bugs.
