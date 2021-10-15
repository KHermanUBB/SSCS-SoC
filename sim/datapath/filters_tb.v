/*
Testbench for XST sytnthesis user guide examples
*/
//-----------------------------------------------------------
`include "uprj_netlists.v"
module Filter_behavioral_tb;
  
  parameter N = 16;
  reg clk, rst, en;
  reg signed [N-1:0] X, b0, b1, a0, a1, a2;
  wire [N-1:0] Y, Yir;

  
  
/* Module instantiation */  
 FIR_Filter fir(clk, rst, en, X, b0, b1, Y);
 IIR_Filter   iir(clk, rst, en, X, a0,a1,a2,b0,b1, Yir);
  

/* clock signal generation*/  
initial begin
  clk=0;
  forever #5 clk = ~clk;  
end 
  
initial begin
       X  =0;
       b0 = -2676;
       b1 = 18952;
       a0 = 16;
       a1 = 32;
       a2 = 64;
       en = 0;
       rst = 1'b0;
  #10  rst = 1'b1;
  #10  rst = 1'b0;
        X <= 0 ;
  #15  en = 1'b1;
  #10  en = 1'b0;  
        X <= 0 ;
  #100  en = 1'b1;
  #10  en = 1'b0;  
        X <=  32767 ;
  #100  en = 1'b1;
  #10  en = 1'b0;  
        X <= 0 ; 
  #100  en = 1'b1;
  #10  en = 1'b0; 
        X <= 0 ; 
  #100  en = 1'b1;
  #10  en = 1'b0; 
  #100  en = 1'b1;
  #10  en = 1'b0;  
  #100  en = 1'b1;
  #10  en = 1'b0;  
  #100  en = 1'b1;
  #10  en = 1'b0;  
  #100  en = 1'b1;
  #10  en = 1'b0;   
  #100 $finish;
end
/* Monitor and dump */  
initial begin
 // $monitor ("%t | CLK = %d| D = %d| Q = %d", $time, clk, set, Q2);
    $dumpfile("filters.vcd");
    $dumpvars();
end
endmodule
