// ---------------------------------------------------- //
//        	     DEMODULATOR FILTER RSS
//         Mauricio Montanares, Luis Osses, Max Cerda 2021
// ---------------------------------------------------- //     
//This file is completly based on the paper:
// FPGA-BASED REAL-TIME ACOUSTIC CAMERA USING PDM MEMS MICROPHONES WITH A CUSTOM DEMODULATION FILTER

`define OverSample 32

// =========== Top module START =========== //
module cic #(parameter N =- 2)(
  input clk, rst, we,
  input                       data_in,
  output wire signed [11:0] data_out2
);
  integer i;
  wire signed [6:0] sum1; 
  wire signed [1:0] data_1_in;
  reg         [1:0] ff1[`OverSample];
  wire        [1:0] ff1_last;
  reg         [6:0] ff1out;
  wire        [6:0] dinext1;
  wire        [6:0] ffext1;
  

  wire signed [11:0] sum2;   
  reg         [6:0] ff2[`OverSample];
  wire        [6:0] ff2_last;
  reg         [11:0] ff2out;
  wire        [11:0] dinext2;
  wire        [11:0] ffext2;


   /* input 2'complement extension */
   assign data_1_in = (data_in == 1'b0) ? 2'b11 : 2'b01;
   assign dinext1 =  {{6{data_1_in[1]}},data_1_in};
   assign ff1_last = ff1[`OverSample-1];
   assign ffext1 =  {{5{ff1_last[1]}}, ff1_last };
   assign sum1 = dinext1-ffext1;


   assign dinext2 =  {{5{ff1out[6]}},ff1out};
   assign ff2_last =ff2[`OverSample-1];
   assign ffext2 =  {{5{ff2_last[6]}}, ff2_last };
   assign sum2 = dinext2 - ffext2;
   assign data_out2 = ff2out;

   always @(posedge clk) begin
      if (rst) begin
         ff1out <=0;
         ff2out <=0;
		 for(i = 0; i<`OverSample; i=i+1 ) begin
		     ff1[i] <= 0;
		     ff2[i] <= 0;
		 end
      end  
      else if (we) begin
    	ff1[0] <= data_1_in;   
		ff2[0] <= ff1out; 	
		for(i = 1; i<`OverSample; i=i+1 ) begin
			ff1[i] <= ff1[i-1];       
            ff2[i] <= ff2[i-1];    
        end
        /*  integrator */
        ff1out <= ff1out + sum1;
        ff2out <= ff2out + sum2;   
      end
    
   end
endmodule



