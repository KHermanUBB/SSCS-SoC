// ---------------------------------------------------- //
//        	     DEMODULATOR FILTER RSS
//         Mauricio Montanares, Luis Osses, Max Cerda 2021
// ---------------------------------------------------- //     
//This file is completly based on the paper:
// FPGA-BASED REAL-TIME ACOUSTIC CAMERA USING PDM MEMS MICROPHONES WITH A CUSTOM DEMODULATION FILTER
`timescale 1ns / 1ps

// =========== Top module START =========== //
module cic #(parameter N = 16)(
  input clk, rst, we,
  input              data_in,
  output reg [N-1:0] data_out
);
   //wire signed [N-1:0] L1_o;
   wire signed[N-1:0] pre_dec_sum;
   wire signed[N-1:0] dec_out;
  
   wire signed [N-1:0] sum0;
   wire signed [N-1:0] sum1;
  
//internal registers ff
  reg [N-1:0] ff0; 
  reg [N-1:0] ff1;
  reg [N-1:0] ff2;
  reg [N-1:0] ff3; 
  reg [N-1:0] ff4;
  reg [N-1:0] ff5;
  reg [N-1:0] ff6; 
  reg [N-1:0] ff7;
  reg [N-1:0] ff8;
  reg [N-1:0] ff9; 
  reg [N-1:0] ff10;
  reg [N-1:0] ff11;
  reg [N-1:0] ff12; 
  reg [N-1:0] ff13;
  reg [N-1:0] ff14;
  reg [N-1:0] ff15; 
  reg [N-1:0] ff16;
  reg [N-1:0] ff17;
  reg [N-1:0] ff18; 
  reg [N-1:0] ff19;
  reg [N-1:0] ff20;
  reg [N-1:0] ff21; 
  reg [N-1:0] ff22;
  reg [N-1:0] ff23;
  reg [N-1:0] ff24; 
  reg [N-1:0] ff25;
  reg [N-1:0] ff26;
  reg [N-1:0] ff27; 
  reg [N-1:0] ff28;
  reg [N-1:0] ff29;
  reg [N-1:0] ff30; 
  reg [N-1:0] ff31;
  reg [N-1:0] ff32;
  
   wire [N-1 : 0] data_N_in;
   assign data_N_in = data_in;
   assign sum0 = data_N_in-ff31;
   assign sum1 = sum0+ff32;
  
  always @(posedge clk)
    begin
      if (rst) begin
        ff0 <= 0;
        ff1 <= 0;
        ff2 <= 0;
        ff3 <= 0;
        ff4 <= 0;
        ff5 <= 0;
        ff6 <= 0;
        ff7 <= 0;
        ff8 <= 0;
        ff9 <= 0;
        ff10 <= 0;
        ff11 <= 0;
        ff12 <= 0;
        ff13 <= 0;
        ff14 <= 0;
        ff15 <= 0;
        ff16 <= 0;
        ff17 <= 0;
        ff18 <= 0;
        ff19 <= 0;
        ff20 <= 0;
        ff21 <= 0;
        ff22 <= 0;
        ff23 <= 0;
        ff24 <= 0;
        ff25 <= 0;
        ff26 <= 0;
        ff27 <= 0;
        ff28 <= 0;
        ff29 <= 0;
        ff30 <= 0;
        ff31 <= 0;
        ff32 <= 0;
        data_out <= 0; 
      end
     
      else if (we) begin
        ff0 <= data_in;
        ff1 <= ff0;
        ff2 <= ff1;
        ff3 <= ff2;
        ff4 <= ff3;
        ff5 <= ff4;
        ff6 <= ff5;
        ff7 <= ff6;
        ff8 <= ff7;
        ff9 <= ff8;
        ff10 <= ff9;
        ff11 <= ff10;
        ff12 <= ff11;
        ff13 <= ff12;
        ff14 <= ff13;
        ff15 <= ff14;
        ff16 <= ff15;
        ff17 <= ff16;
        ff18 <= ff17;
        ff19 <= ff18;
        ff20 <= ff19;
        ff21 <= ff20;
        ff22 <= ff21;
        ff23 <= ff22;
        ff24 <= ff23;
        ff25 <= ff24;
        ff26 <= ff25;
        ff27 <= ff26;
        ff28 <= ff27;
        ff29 <= ff28;
        ff30 <= ff29;
        ff31 <= ff30;

        ff32 <= sum1;

        
        data_out <= dec_out; //Top module OUT!     
      end
    end
    
    
    //INSTANCES OTHER MODULES
   //PRE_DEC pre_dec(sum1,rst,clk,we,Ctrl,pre_dec_sum);
   //DEC dec(clk,we,rst,pre_dec_sum,dec_out);
     DEC dec(clk,we,rst,sum1,dec_out);
endmodule
// =========== Top module END =========== //


// ---------- PRE_DEC module START ---------- //
module PRE_DEC#(parameter N=16)(
  				input[N-1:0] data_in,
  				input rst,clk,we,Ctrl,
  				output reg[N-1:0] data_out);
  //internal wires
  wire [N-1:0] sum;
  wire[N-1:0] mux_o;
  wire[N-1:0] ff_to_sum;
  
  //combinational partassign blocks
  assign mux_o = (Ctrl) ? 0:data_in; //mux
  assign sum = data_in+ff_to_sum;	 //sum
  
  //secuential part
  always @(posedge clk)
    begin
      if (rst) begin
        data_out <= 0; 
      end
      else if (we) begin
        data_out <= sum; //storage sum
      end
   end
  
  //connection ff-sum
  FF ff(mux_o,rst,clk,we,ff_to_sum);
  
endmodule
// ---------- PRE_DEC module END ---------- //

// ---------- FF module START ---------- //
module FF#(parameter N=16)(
  	input[N-1:0] data_i,
	input rst,clk,we,
  	output reg[N-1:0] Q);
	
  always @(posedge clk) // Evento que ocurre con el flanco de subida
	begin
      if(rst) Q<=0; // Reset a 1, Q a 0 Q <= D
         else if(we)
			Q<=data_i;
	end

endmodule
// ---------- FF module END ---------- //


// ---------- DEC module START ---------- //
module DEC #(parameter N=16, parameter R=10)(
//n: bit size
//R: Decimation factor (R)
 
input clk, we, rst,
input [N-1:0] data_in,
output reg [N-1:0] data_out);
    
    
//INTERNAL REGISTERS
 reg [3:0] local_counter = 0;  

  // ============= DEC LOGIC START ============= //
  always @(posedge clk)
     begin
       if (rst) begin
         data_out <= 0;
         local_counter <= 0;
       end
       else begin
            if(we) begin
              if (data_in >= 0 || data_in <= 0) begin
             		local_counter <= local_counter + 1;               
                if (local_counter == R) begin
                      data_out <= data_in; //out! (every M clk cycles)
                      local_counter <= 1;  //reset local counter
                   end  
                end
             end
    	// ============= DEC LOGIC END ============== //   
   		end   
  end
endmodule 
// ---------- DEC module START ---------- //
