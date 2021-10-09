//////////////////////////////////////////////////////////////////////////////////
// Module Name:    MULTIPLICADOR POR CONSTANTE.
// Luis Osses Gutierrez
//////////////////////////////////////////////////////////////////////////////////
module MULTI   #(parameter n =16)  (data_i,amplify, multiplier_o);
  
  input   wire [2*n-1:0]   data_i;
  input   wire [n-1:0]     amplify;
  output  wire [2*n-1:0]   multiplier_o;
    
  assign multiplier_o = data_i * amplify; 
  
endmodule
