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
| [`And2`](lambdalib/stdlib/la_and2/la_and2.v) | 2-input AND | [`Nand2`](lambdalib/stdlib/la_nand2/la_nand2.v) | 2-input NAND |
| [`And3`](lambdalib/stdlib/la_and3/la_and3.v) | 3-input AND | [`Nand3`](lambdalib/stdlib/la_nand3/la_nand3.v) | 3-input NAND |
| [`And4`](lambdalib/stdlib/la_and4/la_and4.v) | 4-input AND | [`Nand4`](lambdalib/stdlib/la_nand4/la_nand4.v) | 4-input NAND |
| [`Or2`](lambdalib/stdlib/la_or2/la_or2.v) | 2-input OR | [`Nor2`](lambdalib/stdlib/la_nor2/la_nor2.v) | 2-input NOR |
| [`Or3`](lambdalib/stdlib/la_or3/la_or3.v) | 3-input OR | [`Nor3`](lambdalib/stdlib/la_nor3/la_nor3.v) | 3-input NOR |
| [`Or4`](lambdalib/stdlib/la_or4/la_or4.v) | 4-input OR | [`Nor4`](lambdalib/stdlib/la_nor4/la_nor4.v) | 4-input NOR |
| [`Xor2`](lambdalib/stdlib/la_xor2/la_xor2.v) | 2-input XOR | [`Xnor2`](lambdalib/stdlib/la_xnor2/la_xnor2.v) | 2-input XNOR |
| [`Xor3`](lambdalib/stdlib/la_xor3/la_xor3.v) | 3-input XOR | [`Xnor3`](lambdalib/stdlib/la_xnor3/la_xnor3.v) | 3-input XNOR |
| [`Xor4`](lambdalib/stdlib/la_xor4/la_xor4.v) | 4-input XOR | [`Xnor4`](lambdalib/stdlib/la_xnor4/la_xnor4.v) | 4-input XNOR |

#### Buffers and Inverters

| Cell | Description |
|------|-------------|
| [`Buf`](lambdalib/stdlib/la_buf/la_buf.v) | Non-inverting buffer |
| [`Inv`](lambdalib/stdlib/la_inv/la_inv.v) | Inverter |
| [`Delay`](lambdalib/stdlib/la_delay/la_delay.v) | Delay element |

#### Complex Logic (AOI/OAI)

| Cell | Description | Cell | Description |
|------|-------------|------|-------------|
| [`Ao21`](lambdalib/stdlib/la_ao21/la_ao21.v) | AND-OR (2-1) | [`Aoi21`](lambdalib/stdlib/la_aoi21/la_aoi21.v) | AND-OR-Invert (2-1) |
| [`Ao211`](lambdalib/stdlib/la_ao211/la_ao211.v) | AND-OR (2-1-1) | [`Aoi211`](lambdalib/stdlib/la_aoi211/la_aoi211.v) | AND-OR-Invert (2-1-1) |
| [`Ao22`](lambdalib/stdlib/la_ao22/la_ao22.v) | AND-OR (2-2) | [`Aoi22`](lambdalib/stdlib/la_aoi22/la_aoi22.v) | AND-OR-Invert (2-2) |
| [`Ao221`](lambdalib/stdlib/la_ao221/la_ao221.v) | AND-OR (2-2-1) | [`Aoi221`](lambdalib/stdlib/la_aoi221/la_aoi221.v) | AND-OR-Invert (2-2-1) |
| [`Ao222`](lambdalib/stdlib/la_ao222/la_ao222.v) | AND-OR (2-2-2) | [`Aoi222`](lambdalib/stdlib/la_aoi222/la_aoi222.v) | AND-OR-Invert (2-2-2) |
| [`Ao31`](lambdalib/stdlib/la_ao31/la_ao31.v) | AND-OR (3-1) | [`Aoi31`](lambdalib/stdlib/la_aoi31/la_aoi31.v) | AND-OR-Invert (3-1) |
| [`Ao311`](lambdalib/stdlib/la_ao311/la_ao311.v) | AND-OR (3-1-1) | [`Aoi311`](lambdalib/stdlib/la_aoi311/la_aoi311.v) | AND-OR-Invert (3-1-1) |
| [`Ao32`](lambdalib/stdlib/la_ao32/la_ao32.v) | AND-OR (3-2) | [`Aoi32`](lambdalib/stdlib/la_aoi32/la_aoi32.v) | AND-OR-Invert (3-2) |
| [`Ao33`](lambdalib/stdlib/la_ao33/la_ao33.v) | AND-OR (3-3) | [`Aoi33`](lambdalib/stdlib/la_aoi33/la_aoi33.v) | AND-OR-Invert (3-3) |
| [`Oa21`](lambdalib/stdlib/la_oa21/la_oa21.v) | OR-AND (2-1) | [`Oai21`](lambdalib/stdlib/la_oai21/la_oai21.v) | OR-AND-Invert (2-1) |
| [`Oa211`](lambdalib/stdlib/la_oa211/la_oa211.v) | OR-AND (2-1-1) | [`Oai211`](lambdalib/stdlib/la_oai211/la_oai211.v) | OR-AND-Invert (2-1-1) |
| [`Oa22`](lambdalib/stdlib/la_oa22/la_oa22.v) | OR-AND (2-2) | [`Oai22`](lambdalib/stdlib/la_oai22/la_oai22.v) | OR-AND-Invert (2-2) |
| [`Oa221`](lambdalib/stdlib/la_oa221/la_oa221.v) | OR-AND (2-2-1) | [`Oai221`](lambdalib/stdlib/la_oai221/la_oai221.v) | OR-AND-Invert (2-2-1) |
| [`Oa222`](lambdalib/stdlib/la_oa222/la_oa222.v) | OR-AND (2-2-2) | [`Oai222`](lambdalib/stdlib/la_oai222/la_oai222.v) | OR-AND-Invert (2-2-2) |
| [`Oa31`](lambdalib/stdlib/la_oa31/la_oa31.v) | OR-AND (3-1) | [`Oai31`](lambdalib/stdlib/la_oai31/la_oai31.v) | OR-AND-Invert (3-1) |
| [`Oa311`](lambdalib/stdlib/la_oa311/la_oa311.v) | OR-AND (3-1-1) | [`Oai311`](lambdalib/stdlib/la_oai311/la_oai311.v) | OR-AND-Invert (3-1-1) |
| [`Oa32`](lambdalib/stdlib/la_oa32/la_oa32.v) | OR-AND (3-2) | [`Oai32`](lambdalib/stdlib/la_oai32/la_oai32.v) | OR-AND-Invert (3-2) |
| [`Oa33`](lambdalib/stdlib/la_oa33/la_oa33.v) | OR-AND (3-3) | [`Oai33`](lambdalib/stdlib/la_oai33/la_oai33.v) | OR-AND-Invert (3-3) |

#### Multiplexers

| Cell | Description |
|------|-------------|
| [`Mux2`](lambdalib/stdlib/la_mux2/la_mux2.v) | 2:1 multiplexer |
| [`Mux3`](lambdalib/stdlib/la_mux3/la_mux3.v) | 3:1 multiplexer |
| [`Mux4`](lambdalib/stdlib/la_mux4/la_mux4.v) | 4:1 multiplexer |
| [`Muxi2`](lambdalib/stdlib/la_muxi2/la_muxi2.v) | 2:1 inverting multiplexer |
| [`Muxi3`](lambdalib/stdlib/la_muxi3/la_muxi3.v) | 3:1 inverting multiplexer |
| [`Muxi4`](lambdalib/stdlib/la_muxi4/la_muxi4.v) | 4:1 inverting multiplexer |
| [`Dmux2`](lambdalib/stdlib/la_dmux2/la_dmux2.v) | 1:2 demultiplexer |
| [`Dmux3`](lambdalib/stdlib/la_dmux3/la_dmux3.v) | 1:3 demultiplexer |
| [`Dmux4`](lambdalib/stdlib/la_dmux4/la_dmux4.v) | 1:4 demultiplexer |
| [`Dmux5`](lambdalib/stdlib/la_dmux5/la_dmux5.v) | 1:5 demultiplexer |
| [`Dmux6`](lambdalib/stdlib/la_dmux6/la_dmux6.v) | 1:6 demultiplexer |
| [`Dmux7`](lambdalib/stdlib/la_dmux7/la_dmux7.v) | 1:7 demultiplexer |
| [`Dmux8`](lambdalib/stdlib/la_dmux8/la_dmux8.v) | 1:8 demultiplexer |

#### Flip-Flops and Latches

| Cell | Description |
|------|-------------|
| [`Dffq`](lambdalib/stdlib/la_dffq/la_dffq.v) | D flip-flop (Q output) |
| [`Dffqn`](lambdalib/stdlib/la_dffqn/la_dffqn.v) | D flip-flop (Q and QN outputs) |
| [`Dffnq`](lambdalib/stdlib/la_dffnq/la_dffnq.v) | D flip-flop (negative edge) |
| [`Dffrq`](lambdalib/stdlib/la_dffrq/la_dffrq.v) | D flip-flop with async reset |
| [`Dffrqn`](lambdalib/stdlib/la_dffrqn/la_dffrqn.v) | D flip-flop with async reset (Q and QN) |
| [`Dffsq`](lambdalib/stdlib/la_dffsq/la_dffsq.v) | D flip-flop with async set |
| [`Dffsqn`](lambdalib/stdlib/la_dffsqn/la_dffsqn.v) | D flip-flop with async set (Q and QN) |
| [`Sdffq`](lambdalib/stdlib/la_sdffq/la_sdffq.v) | Scan D flip-flop |
| [`Sdffqn`](lambdalib/stdlib/la_sdffqn/la_sdffqn.v) | Scan D flip-flop (Q and QN) |
| [`Sdffrq`](lambdalib/stdlib/la_sdffrq/la_sdffrq.v) | Scan D flip-flop with reset |
| [`Sdffrqn`](lambdalib/stdlib/la_sdffrqn/la_sdffrqn.v) | Scan D flip-flop with reset (Q and QN) |
| [`Sdffsq`](lambdalib/stdlib/la_sdffsq/la_sdffsq.v) | Scan D flip-flop with set |
| [`Sdffsqn`](lambdalib/stdlib/la_sdffsqn/la_sdffsqn.v) | Scan D flip-flop with set (Q and QN) |
| [`Latq`](lambdalib/stdlib/la_latq/la_latq.v) | Transparent latch |
| [`Latnq`](lambdalib/stdlib/la_latnq/la_latnq.v) | Transparent latch (inverted enable) |

#### Clock Tree Cells

| Cell | Description |
|------|-------------|
| [`Clkbuf`](lambdalib/stdlib/la_clkbuf/la_clkbuf.v) | Clock buffer (balanced rise/fall) |
| [`Clkinv`](lambdalib/stdlib/la_clkinv/la_clkinv.v) | Clock inverter |
| [`Clkand2`](lambdalib/stdlib/la_clkand2/la_clkand2.v) | Clock AND gate |
| [`Clknand2`](lambdalib/stdlib/la_clknand2/la_clknand2.v) | Clock NAND gate |
| [`Clkor2`](lambdalib/stdlib/la_clkor2/la_clkor2.v) | Clock OR gate (2-input) |
| [`Clkor4`](lambdalib/stdlib/la_clkor4/la_clkor4.v) | Clock OR gate (4-input) |
| [`Clknor2`](lambdalib/stdlib/la_clknor2/la_clknor2.v) | Clock NOR gate |
| [`Clkxor2`](lambdalib/stdlib/la_clkxor2/la_clkxor2.v) | Clock XOR gate |

#### Arithmetic

| Cell | Description |
|------|-------------|
| [`Csa32`](lambdalib/stdlib/la_csa32/la_csa32.v) | 3:2 carry-save adder |
| [`Csa42`](lambdalib/stdlib/la_csa42/la_csa42.v) | 4:2 carry-save adder |

#### Tie Cells

| Cell | Description |
|------|-------------|
| [`Tiehi`](lambdalib/stdlib/la_tiehi/la_tiehi.v) | Tie to VDD |
| [`Tielo`](lambdalib/stdlib/la_tielo/la_tielo.v) | Tie to VSS |

---

### auxlib - Auxiliary Cells (22 cells)

Special-purpose cells for clock management, synchronization, and power control.

<!-- FIGURE PLACEHOLDER: Add auxiliary cell diagrams
![Auxiliary Cells](docs/images/auxlib-diagrams.png)
-->

#### Synchronizers

| Cell | Description |
|------|-------------|
| [`Dsync`](lambdalib/auxlib/la_dsync/la_dsync.v) | Double-stage synchronizer for CDC |
| [`Rsync`](lambdalib/auxlib/la_rsync/la_rsync.v) | Reset synchronizer |
| [`Drsync`](lambdalib/auxlib/la_drsync/la_drsync.v) | Double reset synchronizer |

#### Clock Management

| Cell | Description |
|------|-------------|
| [`Clkmux2`](lambdalib/auxlib/la_clkmux2/la_clkmux2.v) | Glitchless 2:1 clock multiplexer |
| [`Clkmux4`](lambdalib/auxlib/la_clkmux4/la_clkmux4.v) | Glitchless 4:1 clock multiplexer |
| [`Clkicgand`](lambdalib/auxlib/la_clkicgand/la_clkicgand.v) | Integrated clock gate (AND-based) |
| [`Clkicgor`](lambdalib/auxlib/la_clkicgor/la_clkicgor.v) | Integrated clock gate (OR-based) |

#### I/O Buffers

| Cell | Description |
|------|-------------|
| [`Ibuf`](lambdalib/auxlib/la_ibuf/la_ibuf.v) | Input buffer |
| [`Obuf`](lambdalib/auxlib/la_obuf/la_obuf.v) | Output buffer |
| [`Tbuf`](lambdalib/auxlib/la_tbuf/la_tbuf.v) | Tri-state buffer |
| [`Idiff`](lambdalib/auxlib/la_idiff/la_idiff.v) | Differential input buffer |
| [`Odiff`](lambdalib/auxlib/la_odiff/la_odiff.v) | Differential output buffer |

#### DDR Cells

| Cell | Description |
|------|-------------|
| [`Iddr`](lambdalib/auxlib/la_iddr/la_iddr.v) | Input DDR register |
| [`Oddr`](lambdalib/auxlib/la_oddr/la_oddr.v) | Output DDR register |

#### Power Management

| Cell | Description |
|------|-------------|
| [`Isohi`](lambdalib/auxlib/la_isohi/la_isohi.v) | Isolation cell (output high) |
| [`Isolo`](lambdalib/auxlib/la_isolo/la_isolo.v) | Isolation cell (output low) |
| [`Header`](lambdalib/auxlib/la_header/la_header.v) | Power header switch |
| [`Footer`](lambdalib/auxlib/la_footer/la_footer.v) | Power footer switch |
| [`Pwrbuf`](lambdalib/auxlib/la_pwrbuf/la_pwrbuf.v) | Power distribution buffer |

#### Physical Cells

| Cell | Description |
|------|-------------|
| [`Antenna`](lambdalib/auxlib/la_antenna/la_antenna.v) | Antenna diode for process protection |
| [`Decap`](lambdalib/auxlib/la_decap/la_decap.v) | Decoupling capacitor |
| [`Keeper`](lambdalib/auxlib/la_keeper/la_keeper.v) | State keeper cell |

---

### ramlib - Memory Modules (6 modules)

Parameterizable memory generators with consistent interfaces across technologies.

<!-- FIGURE PLACEHOLDER: Add memory block diagrams
![Memory Architectures](docs/images/ramlib-blocks.png)
-->

| Module | Description | Key Parameters |
|--------|-------------|----------------|
| [`Spram`](lambdalib/ramlib/la_spram/la_spram.v) | Single-port RAM | width, depth |
| [`Dpram`](lambdalib/ramlib/la_dpram/la_dpram.v) | Dual-port RAM | width, depth |
| [`Tdpram`](lambdalib/ramlib/la_tdpram/la_tdpram.v) | True dual-port RAM | width, depth |
| [`Spregfile`](lambdalib/ramlib/la_spregfile/la_spregfile.v) | Single-port register file | width, depth |
| [`Syncfifo`](lambdalib/ramlib/la_syncfifo/la_syncfifo.v) | Synchronous FIFO | width, depth |
| [`Asyncfifo`](lambdalib/ramlib/la_asyncfifo/la_asyncfifo.v) | Asynchronous FIFO (CDC-safe) | width, depth |

---

### iolib - I/O Cells (16 cells)

Complete I/O pad library for chip periphery.

<!-- FIGURE PLACEHOLDER: Add I/O cell cross-section diagrams
![IO Cell Types](docs/images/iolib-cells.png)
-->

#### Digital I/O

| Cell | Description |
|------|-------------|
| [`Iobidir`](lambdalib/iolib/la_iobidir/la_iobidir.v) | Bidirectional I/O pad |
| [`Ioinput`](lambdalib/iolib/la_ioinput/la_ioinput.v) | Input-only pad |
| [`Ioxtal`](lambdalib/iolib/la_ioxtal/la_ioxtal.v) | Crystal oscillator pad |
| [`Iorxdiff`](lambdalib/iolib/la_iorxdiff/la_iorxdiff.v) | Differential receiver (LVDS) |
| [`Iotxdiff`](lambdalib/iolib/la_iotxdiff/la_iotxdiff.v) | Differential transmitter (LVDS) |

#### Analog I/O

| Cell | Description |
|------|-------------|
| [`Ioanalog`](lambdalib/iolib/la_ioanalog/la_ioanalog.v) | Analog pass-through with ESD |

#### Power Pads

| Cell | Description |
|------|-------------|
| [`Iovdd`](lambdalib/iolib/la_iovdd/la_iovdd.v) | Core power (VDD) |
| [`Iovss`](lambdalib/iolib/la_iovss/la_iovss.v) | Core ground (VSS) |
| [`Iovddio`](lambdalib/iolib/la_iovddio/la_iovddio.v) | I/O power (VDDIO) |
| [`Iovssio`](lambdalib/iolib/la_iovssio/la_iovssio.v) | I/O ground (VSSIO) |
| [`Iovdda`](lambdalib/iolib/la_iovdda/la_iovdda.v) | Analog power (VDDA) |
| [`Iovssa`](lambdalib/iolib/la_iovssa/la_iovssa.v) | Analog ground (VSSA) |
| [`Iopoc`](lambdalib/iolib/la_iopoc/la_iopoc.v) | Power-on control |
| [`Iocorner`](lambdalib/iolib/la_iocorner/la_iocorner.v) | Corner cell |
| [`Ioclamp`](lambdalib/iolib/la_ioclamp/la_ioclamp.v) | ESD clamp |
| [`Iocut`](lambdalib/iolib/la_iocut/la_iocut.v) | Power ring cut |

---

### padring - Padring Generator (3 modules)

Automated padring generation with pure Verilog output.

<!-- FIGURE PLACEHOLDER: Add padring example layout
![Padring Example](docs/images/padring-layout.png)
-->

| Module | Description |
|--------|-------------|
| [`Padring`](lambdalib/padring/la_padring/la_padring.v) | Main padring generator |

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

#### Vectorized Logic Gates

| Cell | Description |
|------|-------------|
| [`Vbuf`](lambdalib/veclib/la_vbuf/la_vbuf.v) | Vector buffer |
| [`Vinv`](lambdalib/veclib/la_vinv/la_vinv.v) | Vector inverter |
| [`Vmux`](lambdalib/veclib/la_vmux/la_vmux.v) | General vector multiplexer |
| [`Vmux2`](lambdalib/veclib/la_vmux2/la_vmux2.v) | 2:1 vector multiplexer |
| [`Vmux2b`](lambdalib/veclib/la_vmux2b/la_vmux2b.v) | 2:1 buffered vector multiplexer |
| [`Vmux3`](lambdalib/veclib/la_vmux3/la_vmux3.v) | 3:1 vector multiplexer |
| [`Vmux4`](lambdalib/veclib/la_vmux4/la_vmux4.v) | 4:1 vector multiplexer |
| [`Vmux5`](lambdalib/veclib/la_vmux5/la_vmux5.v) | 5:1 vector multiplexer |
| [`Vmux6`](lambdalib/veclib/la_vmux6/la_vmux6.v) | 6:1 vector multiplexer |
| [`Vmux7`](lambdalib/veclib/la_vmux7/la_vmux7.v) | 7:1 vector multiplexer |
| [`Vmux8`](lambdalib/veclib/la_vmux8/la_vmux8.v) | 8:1 vector multiplexer |

#### Vectorized Registers

| Cell | Description |
|------|-------------|
| [`Vdffq`](lambdalib/veclib/la_vdffq/la_vdffq.v) | Vector D flip-flop |
| [`Vdffnq`](lambdalib/veclib/la_vdffnq/la_vdffnq.v) | Vector D flip-flop (negative edge) |
| [`Vlatq`](lambdalib/veclib/la_vlatq/la_vlatq.v) | Vector latch |
| [`Vlatnq`](lambdalib/veclib/la_vlatnq/la_vlatnq.v) | Vector latch (inverted enable) |

---

### fpgalib - FPGA Primitives (3 cells)

Building blocks for FPGA architectures.

<!-- FIGURE PLACEHOLDER: Add FPGA primitive diagrams
![FPGA Primitives](docs/images/fpgalib-primitives.png)
-->

| Cell | Description |
|------|-------------|
| [`Lut4`](lambdalib/fpgalib/la_lut4/la_lut4.v) | 4-input lookup table |
| [`Ble4p0`](lambdalib/fpgalib/la_ble4p0/la_ble4p0.v) | Basic logic element |
| [`Clb4p0`](lambdalib/fpgalib/la_clb4p0/la_clb4p0.v) | Configurable logic block (4 BLEs) |

---

### analoglib - Analog Circuits (2 modules)

Analog and mixed-signal building blocks.

<!-- FIGURE PLACEHOLDER: Add analog block diagrams
![Analog Blocks](docs/images/analoglib-blocks.png)
-->

| Module | Description |
|--------|-------------|
| [`PLL`](lambdalib/analoglib/la_pll/la_pll.v) | Phase-locked loop |
| [`Ring`](lambdalib/analoglib/la_ring/la_ring.v) | Ring oscillator |


## Contributing

We welcome contributions! Please see our [GitHub Issues](https://github.com/siliconcompiler/lambdalib/issues) for tracking requests and bugs.

## License

MIT License

Copyright (c) 2023 Zero ASIC Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
