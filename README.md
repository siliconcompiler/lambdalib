# Lambdalib

**A Modular Hardware Abstraction Library for Portable ASIC Design**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)

<!-- FIGURE PLACEHOLDER: Add a hero banner image showing the abstraction concept
![Lambdalib Overview](docs/images/lambdalib-banner.png)
-->

## Why Lambdalib?

Lambdalib is a modular hardware abstraction library which decouples design from the manufacturing target. The project was inspired by the Lambda concept invented during the **1978 VLSI revolution by Mead and Conway**. Unfortunately, the elegant single value Lambda approach no longer applies to modern CMOS manufacturing. Lambdalib solves the scaling tech porting problem by raising the abstraction level to the cell/block level.

### The Problem

<!-- FIGURE PLACEHOLDER: Add diagram showing traditional design flow with technology coupling
![Traditional ASIC Design Flow](docs/images/traditional-flow.png)
-->

- Synchronizers, clock gating cells, and I/O pads are technology-specific
- Memory compilers generate different interfaces per foundry
- Analog blocks require complete redesign for each process
- Design teams waste months re-implementing the same functionality

### The Solution

<!-- FIGURE PLACEHOLDER: Add diagram showing Lambdalib abstraction layer
![Lambdalib Abstraction](docs/images/lambdalib-abstraction.png)
-->

Lambdalib provides **technology-agnostic interfaces** for all cells that can't be expressed in pure RTL:

- Write your design once using Lambdalib cells
- Target any supported technology through [Lambdapdk](https://github.com/siliconcompiler/lambdapdk)
- Automatic porting between process nodes
- Proven in multiple production tapeouts

## Key Features

<!-- FIGURE PLACEHOLDER: Add feature icons/graphics
![Key Features](docs/images/features.png)
-->

| Feature | Benefit |
|---------|---------|
| **Technology Independence** | Write once, fabricate anywhere |
| **Complete Cell Library** | 160+ cells covering all common needs |
| **SiliconCompiler Integration** | Seamless ASIC build flow |
| **Parameterizable Cells** | Flexible width, depth, and configuration |
| **Production Proven** | Used in real tapeouts |
| **Open Source** | MIT licensed, free to use and modify |

## Architecture

<!-- FIGURE PLACEHOLDER: Add architecture diagram showing library hierarchy
![Library Architecture](docs/images/architecture.png)
-->

Lambdalib is organized into specialized sub-libraries, each addressing a specific design domain:

```
lambdalib/
├── stdlib/     # Standard digital cells (97 cells)
├── auxlib/     # Special-purpose cells (22 cells)
├── ramlib/     # Memory modules (6 modules)
├── iolib/      # I/O pad cells (16 cells)
├── padring/    # Padring generator (3 modules)
├── veclib/     # Vectorized datapath (15 cells)
├── fpgalib/    # FPGA primitives (3 cells)
└── analoglib/  # Analog circuits (2 modules)
```

## Integration with Lambdapdk

<!-- FIGURE PLACEHOLDER: Add PDK integration flow diagram
![PDK Integration](docs/images/pdk-integration.png)
-->

Lambdalib cells are implemented for the following open source technologies through [Lambdapdk](https://github.com/siliconcompiler/lambdapdk), which provides:

- ASAP7
- FreePDK45
- IHP130
- Skywater130
- GF180MCU

## Design Methodology

1. **One Verilog module per RTL file** - Clean separation of concerns
2. **One Python class per cell** - Encapsulates Verilog and metadata
3. **Consistent naming** - RTL uses `la_` prefix, Python removes it and capitalizes
4. **Technology abstraction** - Generic interfaces, technology-specific implementations
5. **SiliconCompiler native** - All cells are Design subclasses

## Quick Start

### Installation

```bash
git clone https://github.com/siliconcompiler/lambdalib
cd lambdalib
pip install -e .
```

### Creating a Design with Lambdalib Cells

Lambdalib cells are SiliconCompiler `Design` subclasses. Create your own design and add Lambdalib cells as dependencies:

```python
from siliconcompiler import Design
from lambdalib.padring import Padring
from lambdalib.stdlib import Inv, Dffq
from lambdalib.ramlib import Dpram

class MyChip(Design):
    def __init__(self):
        super().__init__('mychip')

        # Set up your design files
        self.set_topmodule('mychip', 'rtl')
        self.add_file('rtl/mychip.v', 'rtl')

        # Add Lambdalib cells as dependencies
        self.add_depfileset(Padring(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Inv(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Dffq(), depfileset='rtl', fileset='rtl')
        self.add_depfileset(Dpram(), depfileset='rtl', fileset='rtl')
```

### Instantiating Cells in Verilog

In your Verilog RTL, instantiate Lambdalib cells using the `la_` prefix:

```verilog
module mychip (
    input  clk,
    input  d,
    output q
);

    // Instantiate a D flip-flop
    la_dffq u_dff (
        .clk(clk),
        .d(d),
        .q(q)
    );

    // Instantiate a dual-port RAM
    la_dpram #(.DW(32), .AW(10)) u_ram (
        .clk(clk),
        // ... port connections
    );

endmodule
```

### Running Synthesis

Generate a fileset and run synthesis with yosys. (or ideally, you should use the free and open source SiliconCompiler, but you do you;-).

```python
if __name__ == "__main__":
    chip = MyChip()
    chip.write_fileset("mychip.f", fileset="rtl")
    # Run: yosys -f mychip.f
```


## Cell Library Reference

### stdlib - Standard Cells (97 cells)

The foundation of digital logic design with optimized implementations for each target technology.

<!-- FIGURE PLACEHOLDER: Add standard cell examples/symbols
![Standard Cell Symbols](docs/images/stdlib-symbols.png)
-->

#### Logic Gates

| Cell | Description | Cell | Description |
|------|-------------|------|-------------|
| `And2` | 2-input AND | `Nand2` | 2-input NAND |
| `And3` | 3-input AND | `Nand3` | 3-input NAND |
| `And4` | 4-input AND | `Nand4` | 4-input NAND |
| `Or2` | 2-input OR | `Nor2` | 2-input NOR |
| `Or3` | 3-input OR | `Nor3` | 3-input NOR |
| `Or4` | 4-input OR | `Nor4` | 4-input NOR |
| `Xor2` | 2-input XOR | `Xnor2` | 2-input XNOR |
| `Xor3` | 3-input XOR | `Xnor3` | 3-input XNOR |
| `Xor4` | 4-input XOR | `Xnor4` | 4-input XNOR |

#### Buffers and Inverters

| Cell | Description |
|------|-------------|
| `Buf` | Non-inverting buffer |
| `Inv` | Inverter |
| `Delay` | Delay element |

#### Complex Logic (AOI/OAI)

| Cell | Description | Cell | Description |
|------|-------------|------|-------------|
| `Ao21` | AND-OR (2-1) | `Aoi21` | AND-OR-Invert (2-1) |
| `Ao211` | AND-OR (2-1-1) | `Aoi211` | AND-OR-Invert (2-1-1) |
| `Ao22` | AND-OR (2-2) | `Aoi22` | AND-OR-Invert (2-2) |
| `Ao221` | AND-OR (2-2-1) | `Aoi221` | AND-OR-Invert (2-2-1) |
| `Ao222` | AND-OR (2-2-2) | `Aoi222` | AND-OR-Invert (2-2-2) |
| `Ao31` | AND-OR (3-1) | `Aoi31` | AND-OR-Invert (3-1) |
| `Ao311` | AND-OR (3-1-1) | `Aoi311` | AND-OR-Invert (3-1-1) |
| `Ao32` | AND-OR (3-2) | `Aoi32` | AND-OR-Invert (3-2) |
| `Ao33` | AND-OR (3-3) | `Aoi33` | AND-OR-Invert (3-3) |
| `Oa21` | OR-AND (2-1) | `Oai21` | OR-AND-Invert (2-1) |
| `Oa211` | OR-AND (2-1-1) | `Oai211` | OR-AND-Invert (2-1-1) |
| `Oa22` | OR-AND (2-2) | `Oai22` | OR-AND-Invert (2-2) |
| `Oa221` | OR-AND (2-2-1) | `Oai221` | OR-AND-Invert (2-2-1) |
| `Oa222` | OR-AND (2-2-2) | `Oai222` | OR-AND-Invert (2-2-2) |
| `Oa31` | OR-AND (3-1) | `Oai31` | OR-AND-Invert (3-1) |
| `Oa311` | OR-AND (3-1-1) | `Oai311` | OR-AND-Invert (3-1-1) |
| `Oa32` | OR-AND (3-2) | `Oai32` | OR-AND-Invert (3-2) |
| `Oa33` | OR-AND (3-3) | `Oai33` | OR-AND-Invert (3-3) |

#### Multiplexers

| Cell | Description |
|------|-------------|
| `Mux2` | 2:1 multiplexer |
| `Mux3` | 3:1 multiplexer |
| `Mux4` | 4:1 multiplexer |
| `Muxi2` | 2:1 inverting multiplexer |
| `Muxi3` | 3:1 inverting multiplexer |
| `Muxi4` | 4:1 inverting multiplexer |
| `Dmux2` | 1:2 demultiplexer |
| `Dmux3` | 1:3 demultiplexer |
| `Dmux4` | 1:4 demultiplexer |
| `Dmux5` | 1:5 demultiplexer |
| `Dmux6` | 1:6 demultiplexer |
| `Dmux7` | 1:7 demultiplexer |
| `Dmux8` | 1:8 demultiplexer |

#### Flip-Flops and Latches

| Cell | Description |
|------|-------------|
| `Dffq` | D flip-flop (Q output) |
| `Dffqn` | D flip-flop (Q and QN outputs) |
| `Dffnq` | D flip-flop (negative edge) |
| `Dffrq` | D flip-flop with async reset |
| `Dffrqn` | D flip-flop with async reset (Q and QN) |
| `Dffsq` | D flip-flop with async set |
| `Dffsqn` | D flip-flop with async set (Q and QN) |
| `Sdffq` | Scan D flip-flop |
| `Sdffqn` | Scan D flip-flop (Q and QN) |
| `Sdffrq` | Scan D flip-flop with reset |
| `Sdffrqn` | Scan D flip-flop with reset (Q and QN) |
| `Sdffsq` | Scan D flip-flop with set |
| `Sdffsqn` | Scan D flip-flop with set (Q and QN) |
| `Latq` | Transparent latch |
| `Latnq` | Transparent latch (inverted enable) |

#### Clock Tree Cells

| Cell | Description |
|------|-------------|
| `Clkbuf` | Clock buffer (balanced rise/fall) |
| `Clkinv` | Clock inverter |
| `Clkand2` | Clock AND gate |
| `Clknand2` | Clock NAND gate |
| `Clkor2` | Clock OR gate (2-input) |
| `Clkor4` | Clock OR gate (4-input) |
| `Clknor2` | Clock NOR gate |
| `Clkxor2` | Clock XOR gate |

#### Arithmetic

| Cell | Description |
|------|-------------|
| `Csa32` | 3:2 carry-save adder |
| `Csa42` | 4:2 carry-save adder |

#### Tie Cells

| Cell | Description |
|------|-------------|
| `Tiehi` | Tie to VDD |
| `Tielo` | Tie to VSS |

---

### auxlib - Auxiliary Cells (22 cells)

Special-purpose cells for clock management, synchronization, and power control.

<!-- FIGURE PLACEHOLDER: Add auxiliary cell diagrams
![Auxiliary Cells](docs/images/auxlib-diagrams.png)
-->

#### Synchronizers

| Cell | Description |
|------|-------------|
| `Dsync` | Double-stage synchronizer for CDC |
| `Rsync` | Reset synchronizer |
| `Drsync` | Double reset synchronizer |

#### Clock Management

| Cell | Description |
|------|-------------|
| `Clkmux2` | Glitchless 2:1 clock multiplexer |
| `Clkmux4` | Glitchless 4:1 clock multiplexer |
| `Clkicgand` | Integrated clock gate (AND-based) |
| `Clkicgor` | Integrated clock gate (OR-based) |

#### I/O Buffers

| Cell | Description |
|------|-------------|
| `Ibuf` | Input buffer |
| `Obuf` | Output buffer |
| `Tbuf` | Tri-state buffer |
| `Idiff` | Differential input buffer |
| `Odiff` | Differential output buffer |

#### DDR Cells

| Cell | Description |
|------|-------------|
| `Iddr` | Input DDR register |
| `Oddr` | Output DDR register |

#### Power Management

| Cell | Description |
|------|-------------|
| `Isohi` | Isolation cell (output high) |
| `Isolo` | Isolation cell (output low) |
| `Header` | Power header switch |
| `Footer` | Power footer switch |
| `Pwrbuf` | Power distribution buffer |

#### Physical Cells

| Cell | Description |
|------|-------------|
| `Antenna` | Antenna diode for process protection |
| `Decap` | Decoupling capacitor |
| `Keeper` | State keeper cell |

---

### ramlib - Memory Modules (6 modules)

Parameterizable memory generators with consistent interfaces across technologies.

<!-- FIGURE PLACEHOLDER: Add memory block diagrams
![Memory Architectures](docs/images/ramlib-blocks.png)
-->

| Module | Description | Key Parameters |
|--------|-------------|----------------|
| `Spram` | Single-port RAM | width, depth |
| `Dpram` | Dual-port RAM | width, depth |
| `Tdpram` | True dual-port RAM | width, depth |
| `Spregfile` | Single-port register file | width, depth |
| `Syncfifo` | Synchronous FIFO | width, depth |
| `Asyncfifo` | Asynchronous FIFO (CDC-safe) | width, depth |

---

### iolib - I/O Cells (16 cells)

Complete I/O pad library for chip periphery.

<!-- FIGURE PLACEHOLDER: Add I/O cell cross-section diagrams
![IO Cell Types](docs/images/iolib-cells.png)
-->

#### Digital I/O

| Cell | Description |
|------|-------------|
| `Iobidir` | Bidirectional I/O pad |
| `Ioinput` | Input-only pad |
| `Ioxtal` | Crystal oscillator pad |

#### Differential I/O

| Cell | Description |
|------|-------------|
| `Iorxdiff` | Differential receiver (LVDS) |
| `Iotxdiff` | Differential transmitter (LVDS) |

#### Analog

| Cell | Description |
|------|-------------|
| `Ioanalog` | Analog pass-through with ESD |

#### Power Pads

| Cell | Description |
|------|-------------|
| `Iovdd` | Core power (VDD) |
| `Iovss` | Core ground (VSS) |
| `Iovddio` | I/O power (VDDIO) |
| `Iovssio` | I/O ground (VSSIO) |
| `Iovdda` | Analog power (VDDA) |
| `Iovssa` | Analog ground (VSSA) |

#### Special

| Cell | Description |
|------|-------------|
| `Iopoc` | Power-on control |
| `Iocorner` | Corner cell |
| `Ioclamp` | ESD clamp |
| `Iocut` | Power ring cut |

---

### padring - Padring Generator (3 modules)

Automated padring generation with pure Verilog output.

<!-- FIGURE PLACEHOLDER: Add padring example layout
![Padring Example](docs/images/padring-layout.png)
-->

| Module | Description |
|--------|-------------|
| `Padring` | Main padring generator |
| `IOAlias` | I/O pad aliasing |
| `IOShort` | I/O pad shorting for test |

**Features:**
- Pure Verilog parameterizable generator
- Support for all 4 sides (North/East/South/West)
- Differential pair handling
- Power section management
- 40-bit per-cell configuration

---

### veclib - Vectorized Cells (15 cells)

Bus-width scalable cells for efficient datapath design.

<!-- FIGURE PLACEHOLDER: Add vectorized cell concept diagram
![Vectorized Cells](docs/images/veclib-concept.png)
-->

#### Vectorized Logic

| Cell | Description |
|------|-------------|
| `Vbuf` | Vector buffer |
| `Vinv` | Vector inverter |

#### Vectorized Multiplexers

| Cell | Description |
|------|-------------|
| `Vmux` | General vector multiplexer |
| `Vmux2` | 2:1 vector multiplexer |
| `Vmux2b` | 2:1 buffered vector multiplexer |
| `Vmux3` | 3:1 vector multiplexer |
| `Vmux4` | 4:1 vector multiplexer |
| `Vmux5` | 5:1 vector multiplexer |
| `Vmux6` | 6:1 vector multiplexer |
| `Vmux7` | 7:1 vector multiplexer |
| `Vmux8` | 8:1 vector multiplexer |

#### Vectorized Registers

| Cell | Description |
|------|-------------|
| `Vdffq` | Vector D flip-flop |
| `Vdffnq` | Vector D flip-flop (negative edge) |
| `Vlatq` | Vector latch |
| `Vlatnq` | Vector latch (inverted enable) |

---

### fpgalib - FPGA Primitives (3 cells)

Building blocks for FPGA architectures.

<!-- FIGURE PLACEHOLDER: Add FPGA primitive diagrams
![FPGA Primitives](docs/images/fpgalib-primitives.png)
-->

| Cell | Description |
|------|-------------|
| `Lut4` | 4-input lookup table |
| `Ble4p0` | Basic logic element |
| `Clb4p0` | Configurable logic block (4 BLEs) |

---

### analoglib - Analog Circuits (2 modules)

Analog and mixed-signal building blocks.

<!-- FIGURE PLACEHOLDER: Add analog block diagrams
![Analog Blocks](docs/images/analoglib-blocks.png)
-->

| Module | Description |
|--------|-------------|
| `PLL` | Phase-locked loop |
| `Ring` | Ring oscillator |


## Contributing

We welcome contributions! Please see our [GitHub Issues](https://github.com/siliconcompiler/lambdalib/issues) for tracking requests and bugs.

## License

MIT License

Copyright (c) 2023 Zero ASIC Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
