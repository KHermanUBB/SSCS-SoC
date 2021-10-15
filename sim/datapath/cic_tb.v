// ---------------------------------------------------- //
//        	     	RSS Test Bench
//         Mauricio Montanares, Luis Osses, Max Cerda 2021
// ---------------------------------------------------- //     
`timescale 1ps / 1ps
`include "uprj_netlists.v"
module testRSS ();
  
  //constants
  parameter N = 16;
  parameter len_data_test = 1000;
  //set counter for FOR LOOP
  integer count;
  integer i;
  integer cout_for_dec = 10;
  integer f;
  //memory for test
  reg data_for_test[len_data_test-1:0];
  
  //  ====== ports initialization begin  ====== //
  
  reg clk, rst;
  reg  data_in, data;
  reg [10:0] idx;
  reg bit;
  wire ce, mclk, ce_pcm;
  wire signed [11:0] data_out2;
  reg [7:0] prescaler;
  wire signed [15:0] fir_out;
  reg signed [15:0] b0;
  reg signed [15:0] b1;
  wire signed [15:0] fir_in;
  

  cic         DUT(clk,rst,ce,data_in, data_out2);
  micclk      clockgen(clk, rst, mclk, ce);
  pcm_clk     pcmclkgen(clk, rst, prescaler, ce_pcm); 
  FIR_Filter  fir(clk, rst, ce_pcm, fir_in, b0, b1, fir_out);
  
  assign fir_in =  {{4{data_out2[11]}},data_out2};


  // ================== TEST BEGING ==================== //
  initial begin
    f = $fopen("Outputs/cic_output.csv","w");
  end
	// ---initial values begin --- //
    initial begin
      clk = 0;
      rst = 0;
      data_in = 0;
      prescaler = 49;
      b0 = 16'h0FFF;
      b1 = 16'h7FFF; 


     //read memory data
  	  $readmemh("InputVectors/sin_for_tb.txt", data_for_test);
     
   end
  // ---initial values end --- //
  
  always@(posedge clk) begin
    if(rst) begin
       data_in<=0;
       idx <=0;
      bit <=1;
    end
    else if (ce) begin
         bit <= bit ^ 1; 
         //data_in <= bit;
         data_in <= data_for_test[idx];
         idx <= idx+1;
    end
end
    
  //clock 
   always # 20833 clk = ~clk;

    //--------- stimulus start! ---------- //

    initial begin
      //put rst
      rst = 1;			//set rst
      @(negedge clk);	//wait for negedge clk
      rst = 0;			//set rst = 0

      // --- Using test_data_input for stimulus DUT --- //

      for(count = 0; count < len_data_test; count = count + 1) begin
        
        data = data_for_test[count];
        if(count == 0) begin
          $display("data_in,data_out_L1,data_out_cic");
          $fwrite(f,"data_in,data_out_L1,data_out_cic,fir_in,fir_out\n");
        end
        if(count!=0 || count == 0) begin
        	$display ("%d,%d,%d",data_for_test[count], DUT.sum1, data_out2);
            $fwrite(f,"%d,%d,%d,%d,%d\n",data_for_test[count], DUT.sum1, data_out2, fir.X1, fir_out); 
          
        end
    //wait for negedge clk for change the values
        @(negedge clk);
      end
      $fclose(f);
       $finish;
    end
  //--------- stimulus END! ---------- //
  
  //--------- dump to file! ---------- //
      initial begin
        $dumpfile ("cic.vcd");
    $dumpvars;
    end
    endmodule
  
  // xxxxxxxxxxxxxxxxxxxx TEST END xxxxxxxxxxxxxxxxxxxx //  
