module SR_latch(
	input clk, 
	input rst, 
	input r, 
	input s, 
	output reg q, 
	output reg qbar); 


always@(posedge clk) begin

    if(rst)	begin
		q <= 0;
		qbar <= 1;
	end
      
	else if(s)	begin
		q <= 1;
		qbar <= 0;
	end

	else if(r) begin
		q <= 0;
		qbar <= 1;
	end

	else if(s == 0 & r == 0) begin
			q <= q;
			qbar <= qbar;
	end

	end

endmodule 
