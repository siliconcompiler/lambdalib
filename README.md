# Lambdalib Introduction

Lambdalib is a modular hardware abstraction library which decouples design from the underlying manufacturing target. Lambdalib defines a set of generic functions that get resolved during the target technology mapping stage.

Lambdalib includes the following hardware categories:

| Category                            | Description                           |
|-------------------------------------|---------------------------------------|
|[stdlib](lambdalib/stdlib/rtl)       | Standard library cells (inv, nand, ff, ...)
|[auxlib](lambdalib/auxlib/rtl)       | Special library cells (antenna, decap, clkmux,...)
|[ramlib](lambdalib/ramlib/rtl)       | Memory (single port, dual port, fifo, ...)
|[iolib](lambdalib/iolib)             | IO cells (bidir, vdd, clamp,...)
|[padring](lambdalib/padring)         | Padring generator
|[vectorlib](lambdalib/vecib/rtl)     | Vectorized library (mux, isolation)
|[fpgalib](lambdalib/fpgalib/rtl)     | FPGA cells (lut4, ble, clb)

The [Lambdapdk](https://github.com/siliconcompiler/lambdapdk) repository demonstrates implementation of the Lambdalib interfaces across a number of open source process technologies.

Lambdalib has been successfully used in multiple tapeouts using [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler).


# Installation

```sh
git clone https://github.com/siliconcompiler/lambdalib
cd lambdalib
python3 -m pip install -e .             # Local install
python3 -m pip install -e .[docs,test]  # Optional step for generating docs and running tests
```

# Examples

The following example illustrate lambdalib use models

## Instantiating a Lambdalib module

This example shows how to instatiate the Padring module in a top level chip design.
We could have chosen any module to instantiate (inverter, flip flop, dual port ram...).


```python
```

To convert the design into a gate level netlist using yosys, just run python script
in the examples folder. A file `chip.vg` will be written to disk in the run directory.

```bash
$ python examples/padring/make.py
```

## Using SiliconCompiler to target a technology

```python
```


# Project Methodology

- One verilog module per RTL file
- One Python module per reusable module
- Class names are RTL module names with "la_" removed and capitalized

# License

[MIT](LICENSE)

# Issues / Bugs

We use [GitHub Issues](https://github.com/siliconcompiler/lambdalib/issues) for tracking requests and bugs.
