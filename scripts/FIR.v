/*
============ FIR filter ====================
*/
module FIR  
  (
    input         clk,
    input         rst,
    input         en,
    input  signed [15:0] X,
    input  signed [15:0] b0,
    input  signed [15:0] b1,
    output signed [15:0] Y
);
  
  reg signed [15:0] X1;

  reg  signed [15:0] Yt;

  wire  signed [2*15:0] prod; 
  wire  signed [2*15:0] prod2; 


  assign prod1 =  (X1*b0) >>> 15;
  assign prod2 =  (X1*b1) >>> 15;

  assign Y = Yt;


  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
      X1 <= 0;
      Yt <= 0;
    end
    else if(en == 1) begin 
      X1 <= X;
      Yt <= prod1+ prod2;
    end
  end

endmodule
