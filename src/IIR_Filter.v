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
    output  [N-1:0] Y);
  
  reg [N-1:0] X1, X2, X3;
  reg [N-1:0] Y1, Y2;
  reg [N-1:0] Yt;
  
  reg [2:0] phase;
  reg cycle_valid;
  
  reg [N-1:0] coeff;
  reg [N-1:0] samplevalue;
  reg [N-1:0] result; 

  assign Y = Yt; 
  
  always@(phase or X1 or X2 or X3 or Y1 or Y2 ) begin

	if (phase == 3'b000) begin
         samplevalue <= X1; 
         coeff <=  a0;
    end 
	else if (phase == 3'b001) begin
         samplevalue <= X2; 
         coeff <=  a1;
    end 
	else if (phase == 3'b010) begin
         samplevalue <= X3; 
         coeff <=  a2;
    end 
	else if (phase == 3'b011) begin
         samplevalue <= Y1; 
         coeff <=  b1;
    end 
	else if (phase == 3'b100) begin
         samplevalue <= Y2; 
         coeff <=  b2;
    end 
    else
         samplevalue <= 0;
  end


  
  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
      Y1 <= 0;
      Y2 <= 0;
      X1 <= 0;
      X2 <= 0;
      X3 <= 0;
      Yt <= 0;
    end
    else if(en == 1'b1) 
    begin 
      Y1 <= Yt;
      Y2 <= Y1;
      X1 <= X;
      X2 <= X1;
      X3 <= X2;
    end
   if(phase == 3'b110)
       Yt <= result;
  end

  always@(posedge clk) begin
    if(rst ==1'b1) 
    begin
		result <= 0;
    end
    else begin
    if(cycle_valid)  
		result <= result + ((samplevalue*coeff) >> 4);
    if(phase == 3'b111)
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
    else if(phase == 3'b101) begin
         cycle_valid <= 0;
         end
   end

  
endmodule


