# IOLIB

## Cell Listing

| Cell                             | Type    | Description                 |
| ---------------------------------|---------|-----------------------------|
[la_iobidir](./rtl/la_iobidir.v)   | Digital | Bidirectional
[la_ioinput](./rtl/la_ioinput.v)   | Digital | Input
[la_ioxtal](./rtl/la_ioxtal.v)     | Digital | Xtal transceiver
[la_iorxdiff](./rtl/la_iorxdiff.v) | Digital | Differential input
[la_iotxdiff](./rtl/la_iotxdiff.v) | Digital | Differential output
[la_ioanalog](./rtl/la_ioanalog.v) | Analog  | Pass through ESD protection
[la_iovdd](./rtl/la_iovdd.v)       | Supply  | Core power
[la_iovss](./rtl/la_iovss.v)       | Supply  | Core ground
[la_iovddio](./rtl/la_iovddio.v)   | Supply  | IO  power
[la_iovssio](./rtl/la_iovssio.v)   | Supply  | IO ground
[la_iovdda](./rtl/la_iovdda.v)     | Supply  | Analog power
[la_iovssa](./rtl/la_iovssa.v)     | Supply  | Analog ground
[la_iopoc](./rtl/la_iopoc.v)       | Supply  | Power on control
[la_iocorner](./rtl/la_iocorner.v) | Supply  | Corner connector
[la_ioclamp](./rtl/la_ioclamp.v)   | Supply  | ESD clamp
[la_iocut](./rtl/la_iocut.v)       | Supply  | Power ring cutter

## PARAMETERS

### CFGW
The `CFGW` parameter defines the width of the configuration bus of the io cell. IO cells generally include a set of configuration inputs for things like drive strength and operating modes. Setting `CFGW` to a large value (eg. 16/32) should have zero impact on the design as the extra bus bits get optimized away during implementation. The connection between the generic `CFG` bus and the technology specific IO cell is done within the technology specific cell wrapper library.

For la_bidir, the first 8 bits of the configuration bus are reserved for the functionality shown in the table below.

| Bit       | Description                                     |
|-----------|-------------------------------------------------|
 CFG[0]     | slew rate control (0=fast, 1 =slow)             |
 CFG[1]     | schmitt trigger select (0=CMOS, 1=schmitt)      |
 CFG[2]     | pull enable (0=no pull, 1=enables weak pull)    |
 CFG[3]     | pull select (1=pull up, 0=pull down)            |
 CFG[7:4]   | drive strength                                  |

#### RINGW
The `RINGW` parameter specifies the number of signals within the power bus that connects all of the io cells together within the padring.

### SIDE
The `SIDE` parameter indicates the placement of a cell instances within a padring.Legal values for `SIDE` are: "NO" (north/top), "EA" (east/right), "WE" (west/left), "SO" (south/bottom). The parameter can be used by the technology specific implementation of `iolib` to selec the native orientation of the cell. Modern process nodes place restrictions on the orientation of transistors and include vertical and horizontal version of all active io cells.

### PROP
The `PROP` parameter can be used by the technology specific `iolib` implementation to select between different variants of the `iolib` cell type. The `PROP` parameter is library specific and should only be used when absolutely necessary. Using this parameter means technology/ip information permeates up through the design (nullifying the benefits of lambdalib).

## Cell Description

## la_iobidir

## la_ioinput

## la_ioxtal

## la_iorxdif

## la_iotxdiff

## la_ioanalog

## la_iovdd

## la_iovss

## la_iovddio

## la_iovssio

## la_iovdda

## la_iovssa

## la_iopoc

## la_iocorner

## la_ioclamp

## la_iocut
