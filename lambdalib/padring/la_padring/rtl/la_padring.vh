/*****************************************************************************
 * Function: Padring Generator Enumeration
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 ****************************************************************************/

// NULL (place holder)
localparam [15:0] NULL      = 16'h00;

// io cells
localparam [15:0] LA_BIDIR  = 16'h01;
localparam [15:0] LA_INPUT  = 16'h02;
localparam [15:0] LA_OUTPUT = 16'h03;
localparam [15:0] LA_ANALOG = 16'h04;
localparam [15:0] LA_XTAL   = 16'h05;
localparam [15:0] LA_RXDIFF = 16'h06;
localparam [15:0] LA_TXDIFF = 16'h07;

// supply cells
localparam [15:0] LA_VDDIO  = 16'h10;
localparam [15:0] LA_VSSIO  = 16'h11;
localparam [15:0] LA_VDD    = 16'h12;
localparam [15:0] LA_VSS    = 16'h13;
localparam [15:0] LA_VDDA   = 16'h14;
localparam [15:0] LA_VSSA   = 16'h15;
localparam [15:0] LA_POC    = 16'h16;
localparam [15:0] LA_CUT    = 16'h17;
localparam [15:0] LA_CLAMP  = 16'h18;
