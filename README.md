# Lambdalib Introduction

Lambdalib is a modular hardware abstraction layer that helps decouple hardware design from manufacturing technology and proprietary IP. Lambdalib defines a set of technology independent generic functions that can be directly instantiated within the design. Technology specific implementations can be linked in at compile time.

Lambdalib includes the following hardware categories:

| Category                  | Description|
|---------------------------|------------|
|[stdlib](lambdalib/stdlib/rtl)       | Standard cells (inv, nand, ff, ...)
|[ramlib](lambdalib/ramlib/rtl)       | Memory (single port, dual port, fifo, ...)
|[iolib](lambdalib/iolib/rtl)         | IO cells (bidir, vdd, clamp,...)
|[padring](lambdalib/padring/rtl)     | Padring generator
|[vectorlib](lambdalib/vectorlib/rtl) | Vectorized helper library (mux, isolation)
|[syslib](lambdalib/syslib/rtl)       | Vendor agnostic peripheral interface(uart, i2c,...)

The [Lambdapdk](https://github.com/siliconcompiler/lambdapdk) repository demonstrates implementation of the Lambdalib interfaces across a number of open source process technologies.

Lambdalib has successfully used in multiple tapeouts using [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler).

# License

[MIT](LICENSE)
# Issues / Bugs

We use [GitHub Issues](https://github.com/siliconcompiler/lambdalib/issues)
for tracking requests and bugs.
