/*****************************************************************************
 * Function: Padring Generator Enumeration
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 ****************************************************************************/

// NULL (unused, catchall)
localparam [7:0] NULL      = 8'h00;

// signals
localparam [7:0] LA_BIDIR  = 8'h01;
localparam [7:0] LA_INPUT  = 8'h02;
localparam [7:0] LA_OUTPUT = 8'h03;
localparam [7:0] LA_ANALOG = 8'h04;
localparam [7:0] LA_XTAL   = 8'h05;
localparam [7:0] LA_RXDIFF = 8'h06;
localparam [7:0] LA_TXDIFF = 8'h07;

// supplies
localparam [7:0] LA_VDDIO  = 8'h10;
localparam [7:0] LA_VSSIO  = 8'h11;
localparam [7:0] LA_VDD    = 8'h12;
localparam [7:0] LA_VSS    = 8'h13;
localparam [7:0] LA_VDDA   = 8'h14;
localparam [7:0] LA_VSSA   = 8'h15;
localparam [7:0] LA_POC    = 8'h16;
localparam [7:0] LA_CUT    = 8'h17;
