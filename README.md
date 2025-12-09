# Lambdalib Introduction

Lambdalib is a modular hardware abstraction library which decouples design from the manufacturing target. The project was inspired by the `Lambda` concept invented during the [1978 VLSI revolution by Mead and Conway](https://en.wikipedia.org/wiki/Mead%E2%80%93Conway_VLSI_chip_design_revolution).

The original single value Lambda approach no longer applies to modern CMOS manufacturing, so Lambdalib has raised the abstraction level to the cell/block level to enable automated porting between compilation targets.

Lambdalib abstracts away technology specific design modules that cannot be cleanly expressed in technology agnostic RTL Verilog code (eg. synchronizers, analog circuits, io cells, etc.)

The table below summarizes the categories of cells available.

| Category                        | Description                           |
|---------------------------------|---------------------------------------|
|[stdlib](lambdalib/stdlib)       | Standard cells (inv, nand, ff, ...)
|[auxlib](lambdalib/auxlib)       | Special cells (antenna, decap, clkmux,...)
|[ramlib](lambdalib/ramlib)       | Memory (single port, dual port, fifo, ...)
|[iolib](lambdalib/iolib)         | IO cells (bidir, vdd, clamp,...)
|[padring](lambdalib/padring)     | Padring generator
|[veclib](lambdalib/veclib)       | Vectorized datapath cells (mux, buf,..)
|[fpgalib](lambdalib/fpgalib)     | FPGA cells (lut4, ble, clb)

The [Lambdapdk](https://github.com/siliconcompiler/lambdapdk) repository demonstrates implementation of the Lambdalib interfaces across a number of open source process technologies.

Lambdalib has been successfully used in multiple tapeouts using [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler).

# Installation

```bash
git clone https://github.com/zeroasiccorp/lambdalib
cd lambdalib
pip install --upgrade pip
pip install -e .
```

# Examples

## Instantiating a Lambdalib module

This example shows how to instantiate the Padring module in a top level chip design.
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
