/*
with 8 MHz cristal 
PLL feedback divider = 18 
18 *8 = 144 
main clock 
PLL 1 divider  = 6
144/6 = 24
second clock 
144/3 = 48
*/

module micclk(clk, rst, mclk, ce_pdm);
  input clk, rst;
  output mclk;
  output ce_pdm;
  
  reg  tmp1, tmp2;
  
  assign mclk = ~(tmp1 | tmp2);
  reg [3:0] cnt1, cnt2;

/* delay one cycle vs. MIC Clk*/
  assign ce_pdm = cnt1==4'b001 ? 1 : 0;

  always @(posedge clk)
    begin
      if (rst) begin
            cnt1 <= 0;
            tmp1 <= 0;
      end
      else
        cnt1 <= cnt1 + 1;
      if (cnt1 >=  2)
            tmp1 <=  1'b1;
      if (cnt1 == 4) begin
          cnt1 <= 0;
          tmp1 <= 0;
      end
    end
  
  always @(negedge clk)
    begin
      if (rst) begin
            cnt2 <= 0;
            tmp2 <= 0;
      end
      else
        cnt2 <= cnt2 + 1;
      if (cnt2 >=  2)
            tmp2 <=  1'b1;
      if (cnt2 == 4) begin
          cnt2 <= 0;
          tmp2 <= 0;
      end
    end
endmodule


module pcm_clk(clk, rst, prescaler, ce_pcm); 

  input clk, rst;
  input [9:0] prescaler;
  output reg ce_pcm;
  
  reg [9:0] count;
  
  always@(posedge clk) begin 
    if(rst)begin 
      ce_pcm <=0;
      count <= 0;
    end
    else if(count == prescaler) begin
        ce_pcm <= 1;
        count <=0;
    end
    else begin
    	count <= count + 1;
        ce_pcm <= 0;
    end
    
  end

endmodule 
