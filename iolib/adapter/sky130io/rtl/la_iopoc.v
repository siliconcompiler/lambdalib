module la_iopoc
  #(parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8         // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring, // generic io-ring interface
    output 	      poc // power valid for core logic
    );

endmodule
