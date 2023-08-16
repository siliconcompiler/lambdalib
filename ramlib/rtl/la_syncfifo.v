/*****************************************************************************
 * Function: Synchronous FIFO
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a wrapper for selecting from a set of hardened memory macros.
 *
 ****************************************************************************/

module la_syncfifo
  #(parameter DW        = 32,       // Memory width
    parameter DEPTH     = 4,        // FIFO depth
    parameter NS        = 1,        // Number of power supplies
    parameter CHAOS     = 1,        // generates random full logic when set
    parameter CTRLW     = 1,        // width of asic ctrl interface
    parameter TESTW     = 1,        // width of asic test interface
    parameter TYPE      = "DEFAULT" // Pass through variable for hard macro
    )
   (// common clock, reset, power, ctrl
    input 	      clk,
    input 	      nreset,
    input 	      vss, // ground signal
    input [NS-1:0]    vdd, // supplies
    input 	      chaosmode,// randomly assert fifo full when set
    input [CTRLW-1:0] ctrl, // pass through ASIC control interface
    input [TESTW-1:0] test, // pass through ASIC test interface
    // write input
    input 	      wr_en, // write fifo
    input [DW-1:0]    wr_din, // data to write
    output 	      wr_full, // fifo full
    // read output
    input 	      rd_en, // read fifo
    output [DW-1:0]   rd_dout, // output data
    output 	      rd_empty // fifo is empty
    );

   // local params
   parameter AW  = $clog2(DEPTH);

   // local wires
   reg [AW:0] 	      wr_addr;
   reg [AW:0] 	      rd_addr;
   wire 	      fifo_read;
   wire 	      fifo_write;

   //############################
   // Randomly Asserts FIFO full
   //############################

   generate
      if (CHAOS)
	begin
	   // TODO: implement LFSR
	   reg chaosfull;
	   always @ (posedge clk or negedge nreset)
	     if (~nreset)
	       chaosfull <= 1'b0;
	     else
	       chaosfull <= ~chaosfull;
	end
      else
	begin
	   wire chaosfull;
	   assign chaosfull = 1'b0;
	end

   endgenerate

   //############################
   // FIFO Empty/Full
   //############################

   assign wr_full     = (chaosfull & chaosmode) |
			{~wr_addr[AW], wr_addr[AW-1:0]} == rd_addr[AW:0];

   assign rd_empty    = wr_addr[AW:0] == rd_addr[AW:0];

   assign fifo_read   = rd_en & ~rd_empty;

   assign fifo_write  = wr_en & ~wr_full;

   //############################
   // FIFO Pointers
   //############################

   always @ (posedge clk or negedge nreset)
     if(~nreset)
       begin
          wr_addr[AW:0]    <= 'd0;
          rd_addr[AW:0]    <= 'b0;
       end
     else if(fifo_write & fifo_read)
       begin
	  wr_addr[AW:0] <= wr_addr[AW:0] + 'd1;
	  rd_addr[AW:0] <= rd_addr[AW:0] + 'd1;
       end
     else if(fifo_write)
       begin
	  wr_addr[AW:0] <= wr_addr[AW:0] + 'd1;
       end
     else if(fifo_read)
       begin
          rd_addr[AW:0] <= rd_addr[AW:0] + 'd1;
       end

   //###########################
   //# Dual Port Memory
   //###########################

   reg [DW-1:0] 	ram[DEPTH-1:0];

   // Write port (FIFO input)
   always @(posedge clk)
     if(wr_en & ~wr_full)
       ram[wr_addr[AW-1:0]] <= wr_din[DW-1:0];

   // Read port (FIFO output)
   assign rd_dout[DW-1:0] = ram[rd_addr[AW-1:0]];

endmodule
