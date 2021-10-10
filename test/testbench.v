/*
Testbench for XST sytnthesis user guide examples
*/
//-----------------------------------------------------------
module Filter_behavioral_tb;
  
  parameter N = 16;
  reg clk, rst, en;
  reg [N-1:0] X, b0, b1;
  wire [N-1:0] Y;

  
  
/* Module instantiation */  
 optFIR_Filter fir(clk, rst, en, X, b0, b1, Y);
  

/* clock signal generation*/  
initial begin
  clk=0;
  forever #5 clk = ~clk;  
end 
  
initial begin
       X  = 1;
       b0 = 16;
       b1 = 32;
       en = 0;
       rst = 1'b0;
  #10  rst = 1'b1;
  #10  rst = 1'b0;
        X <= 2 ;
  #15  en = 1'b1;
  #10  en = 1'b0;  
        X <= 3 ;
  #100  en = 1'b1;
  #10  en = 1'b0;  
        X <= 4 ;
  #100  en = 1'b1;
  #10  en = 1'b0;  
        X <= 5 ; 
  #100  en = 1'b1;
  #10  en = 1'b0; 
        X <= 6 ; 
  #100  en = 1'b1;
  #10  en = 1'b0;  
  #100 $finish;
end
/* Monitor and dump */  
initial begin
 // $monitor ("%t | CLK = %d| D = %d| Q = %d", $time, clk, set, Q2);
    $dumpfile("dump.vcd");
    $dumpvars();
end
endmodule
