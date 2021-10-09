`timescale 1ns / 1ps
/*
============ FIR filter ====================
*/
module FIR_Filter
  #(parameter N  = 16)
  (
    input         clk,
    input         rst,
    input         en,
    input [N-1:0] X,
    input [N-1:0] b0,
    input [N-1:0] b1,
    input [N-1:0] b2,
    input [N-1:0] b3,
    output reg [N-1:0]   Y);
  
  reg [N-1:0] X1, X2, X3;
  //reg [N-1:0] Yt;
  
 // assign Y = Yt;
 // assign Yt = (X*b0 + X1*b1 + X2*b2 + X3*b3) >> SHIFT;
  
  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
      X1 <= 0;
      X2 <= 0;
      X3 <= 0;
      Y <= 0;
    end
    else if(en == 1'b1) 
    begin 
      X1 <= X;
      X2 <= X1;
      X3 <= X2;
      Y <= (X*b0 + X1*b1 + X2*b2 + X3*b3) >> 4;
    end
  end
  
endmodule
