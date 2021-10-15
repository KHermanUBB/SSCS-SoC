// ---------------------------------------------------- //
//        	     	RSS Test Bench
//         Mauricio Montanares, Luis Osses, Max Cerda 2021
// ---------------------------------------------------- //     
`timescale 1ps / 1ps
// comment for GL
`include "uprj_netlists.v"
module datapath_tb ();
  
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
  wire ce_pdm, mclk, ce_pcm;
  wire signed [11:0] data_out2;
  reg [7:0] prescaler;
  wire signed [15:0] fir_out;
  reg signed [15:0] b0;
  reg signed [15:0] b1;
  wire signed [15:0] fir_in;
  reg      valid_i;
  reg  mclear;
  wire  ack_o;
  wire [15:0] dat_o;
  wire io_in;
  wire cmp;
  reg VCC;
  reg VSS;
  reg [31:0] adr_i;
  reg [15:0] dat_i;
  reg        strb_i;

 micclk      clockgen(clk, rst, mclk, ce_pdm);
 pcm_clk     pcmclkgen(clk, rst, prescaler, ce_pcm); 

SonarOnChip   soc1(

// uncomment for GL
//    .VGND(VSS),
//    .VPWR(VCC),
    .wb_clk_i(clk),
    .wb_rst_i(rst),
    .wb_valid_i(valid_i),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o),
    .wbs_dat_o(dat_o),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in),
    .mclear(mclear),
    .cmp(cmp)
	);

assign io_in = data_in;



  // ================== TEST BEGING ==================== //
  initial begin
    f = $fopen("Outputs/dp_output.csv","w");
  end
	// ---initial values begin --- //
    initial begin
      clk = 0;
      rst = 0;
      data_in = 0;
      prescaler = 49;
      adr_i = 0;
      strb_i = 0; 
      valid_i = 0;
      mclear = 0;
      VCC =1'b1;
      VSS =1'b0;

     //read memory data
  	  //$readmemh("InputVectors/sin_for_tb.txt", data_for_test);


   end
  // ---initial values end --- //
  
  always@(posedge clk) begin
    if(rst) begin
       data_in<=0;
       idx <=0;
      bit <=1;
    end
    else if (ce_pdm) begin
         bit <= bit ^ 1; 
         data_in <= bit;
        // data_in <= data_for_test[idx];
         idx <= idx+1;
    end

    if(idx == 20)
       mclear <=1;
    if(idx == 21)
       mclear <=0;
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
         //  $display("data_in,data_out_L1,data_out_cic");
         // $fwrite(f,"data_in,data_out_L1,data_out_cic,fir_out\n");
        end
        if(count!=0 || count == 0) begin
        	//$display ("%d,%d,%d",data_for_test[count], data_out2);
           // $fwrite(f,"%d,%d,%d,\n",data_for_test[count],data_out2, fir_out); 
          
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
        $dumpfile ("datapath.vcd");
    $dumpvars;
    end
    endmodule
  
  // xxxxxxxxxxxxxxxxxxxx TEST END xxxxxxxxxxxxxxxxxxxx //  
