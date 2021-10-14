// Code your design here
//maximiliano cerda cid

module comparator #(parameter n=16) (data_i,threshold,compare_o);
  input wire    [n-1:0] data_i, threshold; //maf filter output and treshold value  
  output wire           compare_o; //output of the compare block
  //reg compare_o;

  assign compare_o = (data_i > threshold) ? 1'b1:1'b0;

endmodule
