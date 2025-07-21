//########################################################################
// Common Padring Definitions
//########################################################################

`include "la_padring.vh"

//########################################################################
// Total number of IO cells in one padring side (including power)
//########################################################################

// 16 bidirs
// 12 power ground
// 2 cut cells
// 1 poc

localparam NCELLS = 31;

//########################################################################
// Power sections per side
//########################################################################

localparam NSECTIONS = 1;

//########################################################################
// Tech specific iolib parameters
//########################################################################

// total width of config bus (drive strength, schmitt, ...)
localparam CFGW = 6;

// width of bus that goes around ioring
localparam RINGW = 6;

//########################################################################
// CELLMAP[NCELLS*40-1:0] = {PROP, SECTION, CELL, CPIN#, PIN#}
//########################################################################

/* The CELLMAP vector specifies the type, order,  power rail, and pin
 * connection for each cell placed in a side of the io padring.
 *
 * CELLMAP is used by la_padside which iterates from 0 to NCELLS-1 to
 * instantiate padring cells. The index for that for loop is used
 * to find the power section, pin number, and cell type in the
 * static definition below. The indices of the cells are specified from
 * left to right or top to bottom. The CELLMAP[0] is the first cell
 * placed.
 *
 * All enumerationsa arer defined in the la_iopadring.vh
 *
 * [7:0]   PIN#            = pin# (order 0-255)
 * [15:8]  COMPLEMENT PIN# = pin# (order 0-255)
 * [23:16] CELL            = cell type from lambdalib (0-255)
 * [31:24] SECTION         = power rail selector (when NSECTIONS>1)
 * [39:32] PROP            = cell property (optional)
 *
 */

localparam [NCELLS*40-1:0] CELLMAP =
                           {{NULL, NULL,  LA_CUT,    NULL, NULL},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN15},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN14},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN13},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN12},
                            {NULL, NULL,  LA_VSS,    NULL, NULL},
                            {NULL, NULL,  LA_VDD,    NULL, NULL},
                            {NULL, NULL,  LA_VDDIO,  NULL, NULL},
                            {NULL, NULL,  LA_VSSIO,  NULL, NULL},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN11},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN10},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN9},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN8},
                            {NULL, NULL,  LA_VSS,    NULL, NULL},
                            {NULL, NULL,  LA_VDD,    NULL, NULL},
                            {NULL, NULL,  LA_POC,    NULL, NULL},
                            {NULL, NULL,  LA_VDDIO,  NULL, NULL},
                            {NULL, NULL,  LA_VSSIO,  NULL, NULL},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN7},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN6},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN5},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN4},
                            {NULL, NULL,  LA_VSS,    NULL, NULL},
                            {NULL, NULL,  LA_VDD,    NULL, NULL},
                            {NULL, NULL,  LA_VDDIO,  NULL, NULL},
                            {NULL, NULL,  LA_VSSIO,  NULL, NULL},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN3},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN2},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN1},
                            {NULL, NULL,  LA_BIDIR,  NULL, PIN0},
                            {NULL, NULL,  LA_CUT,    NULL, NULL}};

//########################################################################
// Symmetrical padring for simplicity (not a restriction)
//########################################################################

localparam NO_NCELLS = NCELLS;
localparam EA_NCELLS = NCELLS;
localparam WE_NCELLS = NCELLS;
localparam SO_NCELLS = NCELLS;

localparam NO_NSECTIONS = NSECTIONS;
localparam EA_NSECTIONS = NSECTIONS;
localparam WE_NSECTIONS = NSECTIONS;
localparam SO_NSECTIONS = NSECTIONS;

localparam NO_CELLMAP = CELLMAP;
localparam EA_CELLMAP = CELLMAP;
localparam WE_CELLMAP = CELLMAP;
localparam SO_CELLMAP = CELLMAP;
