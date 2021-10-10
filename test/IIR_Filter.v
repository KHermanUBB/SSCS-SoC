/*
IIR filter for MPW-2
*/
module IIR_Filter
  #(
    parameter N  = 16)
  (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [N-1:0] X,
    input wire [N-1:0] a0,
    input wire [N-1:0] a1,
    input wire [N-1:0] a2,
    input wire [N-1:0] b1,
    input wire [N-1:0] b2,
    output reg  valid,
    output reg [2*N-1:0] Y);
  
  reg [N-1:0] X1, X2;
  reg [N-1:0] Y1, Y2;
  wire [N-1:0] Yt;
  
  
  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
      Y1 <= 0;
      Y2 <= 0;
      X1 <= 0;
      X2 <= 0;
			Y <= 0;
			valid <=0;
    end
    else if(en == 1'b1) 
    begin 
      Y1 <= Y;
      Y2 <= Y1;
      X1 <= X;
      X2 <= X1;
  	  Y <= X*a0 + X1*a1 + a2*X2 - Y1*b1 + Y2*b2;
			valid <=1;
    end
		else 
			valid <=0;
  end
  
endmodule
