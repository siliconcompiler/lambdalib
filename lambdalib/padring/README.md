# PADRING GENERATOR

## Introduction

The lamdbdalib `padring` library is an automated "pure verilog" padring generator with support for cells within the [IOLIB](../../iolib/README.md) io cell library.

## PARAMETERS

### {NO,EA,WE,SO}NCELLS
Specifies the total number of placed cells within one side of the padring, including supply and clamp cells.

### {NO,EA,WE,SO}NPINS
Specifies the total number of logical device pins (pads) connected to one side of the padring, not including supply pins. The `CELLMAP` parameter specifies which one of the pins should be connected to a cell.

### {NO,EA,WE,SO}NSECTIONS
Specifies the total number of power sections within one side of the padring. The `CELLMAP` parameter specifies which one of the power sections should be connected to a cell.

### {NO,EA,WE,SO}CELLMAP
Specifies the type of cells, pin connections, properties, and power connections of all cells in the padring with the exception of filler cells. The physical placement of the cells within the padring shall be done in the order dictated by `CELLMAP`. The CELLMAP is a vector of size NCELLS * 40, with the 40bit vector split into the following fields:

  * PIN[7:0]     = CELLMAP[7:0]   = pin number connected to cell. Positive signal in case of differential pairs.
  * COMP[7:0]    = CELLMAP[15:8]  = pin number of complementary (negative) pad to `PIN`. Used for differential IO cells.
  * TYPE[7:0]    = CELLMAP[23:16] = cell type (see ./la_padring.vh)
  * SECTION[7:0] = CELLMAP[31:24] = padring power section number connected to cell
  * PROP[7:0]    = CELLMAP[39:32] = property passed to technology specific iolib implementation

The header file [la_iopadring.vh](./rtl/la_iopadring.vh) enumerates the cells recognized by the padring generator. `NULL` is a reserved keyword used to specify an empty `CELLMAP` field.

### CFGW
Specifies the width of the configuration bus of the io cell. For a description of uses of `CFGW`, see [IOLIB](../../iolib/README.md).

#### RINGW
The `RINGW` parameter specifies the number of signals within the power bus that connects all of the io cells together within the padring. For a description of uses of `RINGW`, see [IOLIB](../../iolib/README.md).


## Using the Generator

To use the generator, you will need to:
 1. Instantiate the module in your design.
 2. Pass in a set of parameters to configure the cells within the padring.

The full example can be found in the `tb` module placed at the end of the [la_iopadring](rtl/la_iopadring.v) module. To run the small testbench, just execute:

 ```sh
 iverilog la_iopadring.v -DTB_LA_IOPADRING -y . -y ../../iolib/rtl
 ./a.out
 ```

The following excerpt from the testbench illustrate the use of the `CELLMAP`, `NPINS`, and `NCELLS` parameters.

```verilog


 // Setting up your parameters

   localparam CFGW = 8;
   localparam RINGW = 8;
   localparam NPINS = 4;
   localparam NCELLS = 8;
   localparam NSECTIONS = 1;

   // pinmap
   localparam [7:0] PIN_IO0  = 8'h00;
   localparam [7:0] PIN_AN0  = 8'h01;
   localparam [7:0] PIN_RXP  = 8'h02;
   localparam [7:0] PIN_RXN  = 8'h03;

   localparam       NULL     = 8'h0;

   localparam CELLMAP = {{NULL,  NULL,  LA_VSS,     NULL,    NULL},
                        {NULL,  NULL,  LA_BIDIR,   NULL,    PIN_IO0},
                        {NULL,  NULL,  LA_ANALOG,  NULL,    PIN_AN0},
                        {NULL,  NULL,  LA_VDDIO,   NULL,    NULL},
                        {NULL,  NULL,  LA_RXDIFF,  PIN_RXN, PIN_RXP},
                        {NULL,  NULL,  LA_VSS,     NULL,    NULL},
                        {NULL,  NULL,  LA_VSS,     NULL,    NULL},
                        {NULL,  NULL,  LA_VSS,     NULL,    NULL}};

// Instantiating the padring in your design
la_iopadring  #(.CFGW(CFGW),
                .RINGW(RINGW),
                .NO_NPINS(NPINS),
                .EA_NPINS(NPINS),
                .WE_NPINS(NPINS),
                .SO_NPINS(NPINS),
                .NO_NCELLS(NCELLS),
                .EA_NCELLS(NCELLS),
                .WE_NCELLS(NCELLS),
                .SO_NCELLS(NCELLS),
                .NO_CELLMAP(CELLMAP),
                .EA_CELLMAP(CELLMAP),
                .WE_CELLMAP(CELLMAP),
                .SO_CELLMAP(CELLMAP))
la_iopadring(...)



```
