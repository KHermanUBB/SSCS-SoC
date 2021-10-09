// ---------------------------------------------------- //
//        	  MEAN AVERAGE FILTER
//          Mauricio Montanares, 2021
// ---------------------------------------------------- //     

//Enjoy and have a good synthesis.

// ----- PRAMETERS CONFIGURATION ------ //

//parameter N_BITS = 32;  // BIT SIZE 
//parameter DEPTH = 4;    // SIZE OF THE SAMPLES TO MEAN
//parameter SHIFT = 2;    // X/(2^2)


// ------ TOP MODULE START ------- //
//Top module depends of others 3 modules. 
//This modules are DFF (just a N bits register), adder (in a + in b = out c) and a 2er (in >> 2)

module MAF_FILTER
(
  input wire clk,
  input wire rst,
  input wire we,
  input wire [32-1:0]data_in,
  output wire [32-1:0] data_out 
);

wire [32-1:0] connect_wire[4:0]; //wires for interconnect DFFs
wire [32-1:0] connect_wire_adder[4-2:0]; // wires for interconnect adders
  wire [32-1:0] connect_wire_shifter[1:0]; // wires for interconnect last adder with 2er

assign data_out = connect_wire_shifter[0];  //out of the desig will be out of 2er!
assign connect_wire[0] = data_in;

//generate 2 registers and adders (and connect everithing)
genvar i;
generate
   for (i=1; i <= 4; i=i+1) begin
     dff DFF(clk, rst, we, connect_wire[i-1], connect_wire[i]);
      if(i == 1)
        adder ADD(clk, rst, we,connect_wire[i], connect_wire[i+1], connect_wire_adder[0]);
      if( i <= 4-1 && i > 1 )
        adder ADD(clk, rst, we, connect_wire_adder[i-2], connect_wire[i+1], connect_wire_adder[i-1]);
      if( i == 4 )
        shifter shift(clk, rst, we, connect_wire_adder[i-2], connect_wire_shifter[0]);
   end     
endgenerate

endmodule
// ------ TOP MODULE END ------- //


// ------ REG MODULE START ------- //
module dff (
  input      clk,
  input      rst,
  input		 we,
  input      [32-1:0] d,
  output reg     [32-1:0] q);


  always @(posedge clk)
  begin
	if (rst) begin
      	q <= 0;
    end
    else begin
    	if (we) begin
         q <= d;
        end
    end 
  end
endmodule
// ------ REG MODULE END ------- //


// ------ ADDER MODULE START ------- //
module adder(
    input clk,
  	input rst,
    input we,
    input [32-1:0] data_in_a,
    input [32-1:0] data_in_b,
    output reg [32-1:0] data_out_adder);
    
    always @(posedge clk) begin
      if (rst) begin
        data_out_adder <= 0;
      end
      else begin
        if (we) begin
        	data_out_adder <= data_in_a + data_in_b;
        end
      end
     end
    
endmodule
// ------ REG MODULE END ------- //


// ------ SHIFTER MODULE START ------- //
module shifter(
  input clk,
  input rst,
  input we,
  input [32-1:0] data_in_shifter,
  output reg [32-1:0] data_out_shifter);
    always @(posedge clk) begin
      if (rst) begin
      	data_out_shifter <= 0;
      end
      else begin
        if (we) begin
        	data_out_shifter <= data_in_shifter >> 2;
        end
      end
    end
endmodule
// ------ SHIFTER MODULE END ------- //


