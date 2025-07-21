module chip #(parameter NO_NPINS = 16,
              parameter EA_NPINS = 16,
              parameter WE_NPINS = 16,
              parameter SO_NPINS = 16)
   (
    input                VSS,
    input                VDD,
    input                NVCC,
    input                EVCC,
    input                WVCC,
    input                SVCC,
    inout [NO_NPINS-1:0] NIO,
    inout [EA_NPINS-1:0] EIO,
    inout [WE_NPINS-1:0] WIO,
    inout [SO_NPINS-1:0] SIO
    );

`include "chip_iomap.vh"

   wire [NO_NSECTIONS*RINGW-1:0] no_ioring;
   wire [EA_NSECTIONS*RINGW-1:0] ea_ioring;
   wire [WE_NSECTIONS*RINGW-1:0] we_ioring;
   wire [SO_NSECTIONS*RINGW-1:0] so_ioring;

   wire [NO_NPINS-1:0] no_rxd;
   wire [EA_NPINS-1:0] ea_rxd;
   wire [WE_NPINS-1:0] we_rxd;
   wire [SO_NPINS-1:0] so_rxd;

   la_padring #(// padring ctrl widths
                .RINGW(RINGW),
                .CFGW(CFGW),
                //north
                .NO_NPINS(NO_NPINS),
                .NO_NCELLS(NO_NCELLS),
                .NO_NSECTIONS(NO_NSECTIONS),
                .NO_CELLMAP(NO_CELLMAP),
                //east
                .EA_NPINS(EA_NPINS),
                .EA_NCELLS(EA_NCELLS),
                .EA_NSECTIONS(EA_NSECTIONS),
                .EA_CELLMAP(EA_CELLMAP),
                //south
                .SO_NPINS(SO_NPINS),
                .SO_NCELLS(SO_NCELLS),
                .SO_NSECTIONS(SO_NSECTIONS),
                .SO_CELLMAP(SO_CELLMAP),
                //west
                .WE_NPINS(WE_NPINS),
                .WE_NCELLS(WE_NCELLS),
                .WE_NSECTIONS(WE_NSECTIONS),
                .WE_CELLMAP(WE_CELLMAP))
   la_padring(// Outputs
              .no_zp            (no_rxd[NO_NPINS-1:0]),
              .no_zn            (),
              .ea_zp            (ea_rxd[EA_NPINS-1:0]),
              .ea_zn            (),
              .so_zp            (so_rxd[SO_NPINS-1:0]),
              .so_zn            (),
              .we_zp            (we_rxd[WE_NPINS-1:0]),
              .we_zn            (),
              // Inouts
              .vss              (VSS),
              .no_pad           (NIO),
              .no_aio           (),
              .no_vdd           (VDD),
              .no_vddio         (NVCC),
              .no_vssio         (VSS),
              .no_ioring        (no_ioring[NO_NSECTIONS*RINGW-1:0]),
              .ea_pad           (EIO),
              .ea_aio           (),
              .ea_vdd           (VDD),
              .ea_vddio         (EVCC),
              .ea_vssio         (VSS),
              .ea_ioring        (ea_ioring[EA_NSECTIONS*RINGW-1:0]),
              .so_pad           (SIO),
              .so_aio           (),
              .so_vdd           (VDD),
              .so_vddio         (SVCC),
              .so_vssio         (VSS),
              .so_ioring        (so_ioring[SO_NSECTIONS*RINGW-1:0]),
              .we_pad           (WIO),
              .we_aio           (),
              .we_vdd           (VDD),
              .we_vddio         (WVCC),
              .we_vssio         (VSS),
              .we_ioring        (we_ioring[WE_NSECTIONS*RINGW-1:0]),
              // Inputs
              .no_a             ({NO_NPINS{1'b0}}),
              .no_ie            ({NO_NPINS{1'b1}}),
              .no_oe            ({NO_NPINS{1'b0}}),
              .no_pe            ({NO_NPINS{1'b0}}),
              .no_ps            ({NO_NPINS{1'b0}}),
              .no_cfg           ({(NO_NPINS*CFGW){1'b0}}),
              .ea_a             ({EA_NPINS{1'b0}}),
              .ea_ie            ({EA_NPINS{1'b1}}),
              .ea_oe            ({EA_NPINS{1'b0}}),
              .ea_pe            ({EA_NPINS{1'b0}}),
              .ea_ps            ({EA_NPINS{1'b0}}),
              .ea_cfg           ({(EA_NPINS*CFGW){1'b0}}),
              .we_a             ({WE_NPINS{1'b0}}),
              .we_ie            ({WE_NPINS{1'b1}}),
              .we_oe            ({WE_NPINS{1'b0}}),
              .we_pe            ({WE_NPINS{1'b0}}),
              .we_ps            ({WE_NPINS{1'b0}}),
              .we_cfg           ({(WE_NPINS*CFGW){1'b0}}),
              .so_a             ({SO_NPINS{1'b0}}),
              .so_ie            ({SO_NPINS{1'b1}}),
              .so_oe            ({SO_NPINS{1'b0}}),
              .so_pe            ({SO_NPINS{1'b0}}),
              .so_ps            ({SO_NPINS{1'b0}}),
              .so_cfg           ({(SO_NPINS*CFGW){1'b0}})
              );

endmodule
