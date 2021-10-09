// Module Name:    Abs 
// Luis Osses Gutierrez

module Abs
  #(  parameter n=32)( 
  input  [n-1:0] data_in,
  output [n-1:0] data_out);
	
  assign data_out = ~data_in[n-1] ? data_in : ~data_in; 

endmodule
