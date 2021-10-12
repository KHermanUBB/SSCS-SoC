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
    output [N-1:0]   Y);
  
   reg signed [N-1:0] X1, X2, X3, X4;
  reg [2:0] phase;
  wire muxsel;
  reg cycle_valid;
  
  wire signed [N-1:0] coeff;
  reg  signed [N-1:0] samplevalue;
  reg  signed [N-1:0] Yt;
  reg  signed [N-1:0] result; 
  wire  signed [2*N-1:0] prod; 


  assign prod = (samplevalue*coeff) >>> 15;
  assign muxsel = ((phase == 2'b00) || (phase == 2'b11)) ? 0 : 1;
  assign coeff  =  (!muxsel)  ? b0 : b1;
  assign Y = Yt; 
  
  always@(phase or X1 or X2 or X3 or X4) begin

	if (phase == 2'b00)
         samplevalue <= X1; 
   	else if (phase == 2'b01)
         samplevalue <= X2;
   	else if (phase == 2'b10)
         samplevalue <= X3;
   	else if (phase == 2'b11)
			samplevalue <= X4;
    else
         samplevalue <= 0;
  end

/* shift the samples and the result each sample period WE_PCM */  
  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
      X1 <= 0;
      X2 <= 0;
      X3 <= 0;
      X3 <= 0;
    end
    else if(en == 1) 
    begin 
      X1 <= X;
      X2 <= X1;
      X3 <= X2;
      X4 <= X3;
    end
   if(phase == 3'b100)
       Yt <= result;
  end

  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
		result <= 0;
    end
    else begin
    if(cycle_valid)  
		result <= result + prod;
    if(phase == 3'b101)
        result <= 0;
    end
  end

/*phase of the computation*/
   always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
		phase <= 0;
    end
    else if(cycle_valid)
       	phase <= phase + 1;

end

/*phase of the computation*/
   always@(posedge clk) begin
    if(rst ==1'b1) 
		cycle_valid <= 0;
    else if(en == 1'b1) 
         cycle_valid <= 1;
    else if(phase == 3'b011) begin
         cycle_valid <= 0;
         end
  end

endmodule
