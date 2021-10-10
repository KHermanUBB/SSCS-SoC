/*
Sonar on Chip top level module based on user project example
Files:
defines.v - macroodefinitions (come vith Caravel)
Mic_Clk.v - clock divider for MEMS microphones
*/
`include "defines.v"

`define BUS_WIDTH 16 
`define WB_ADDR_BUS = 32
`define WB_DAT_BUS = 32 

module SonarOnChip
  #(parameter INSTANCE_NUM = 1)
   (
  `ifdef USE_POWER_PINS
    inout wire vdda1,	// User area 1 3.3V supply
    inout wire vdda2,	// User area 2 3.3V supply
    inout wire vssa1,	// User area 1 analog ground
    inout wire vssa2,	// User area 2 analog ground
    inout wire vccd1,	// User area 1 1.8V supply
    inout wire vccd2,	// User area 2 1.8v supply
    inout wire vssd1,	// User area 1 digital ground
    inout wire vssd2,	// User area 2 digital ground
  `endif

    // Wishbone Slave ports (WB MI A)
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wb_valid_i,
    input wire  [3:0] wbs_adr_i,
    input wire  [`BUS_WIDTH-1:0] wbs_dat_i,
    input  wire  wbs_strb_i,
    output                    wbs_ack_o,
    output   [`BUS_WIDTH-1:0] wbs_dat_o,

    /* Design specific ports*/
    /* 4.8 MHz clock input */
    input wire  mclk,
    /* PCM pace signal */
    input wire  ce_pcm,
    /* External microphone PDM data */
    input wire  pdm_data_i,
    /* Master clear */
    input wire  mclear,
    /* compare otupt signal*/    
    output wire  cmp,
    /* indicates Hi-Z of the WB*/
    output wire  hi_z
	);


  /*----------------------------- Register map begins ---------------------*/

  localparam  CONTROL_ADDR 		=  'd0;
  localparam  A0_ADDR 			=  'd1;
  localparam  A1_ADDR 			=  'd2; 
  localparam  A2_ADDR 			=  'd3; 
  localparam  B1_ADDR 			=  'd4; 
  localparam  B2_ADDR 			=  'd5; 
  localparam  AMP_ADDR 			=  'd6; 
  localparam  THRESHOLD_ADDR 	=  'd7;
  localparam  TIMER_ADDR 	    =  'd8;
  localparam  PCM_ADDR 	        =  'd9;
  localparam  PCM_LOAD_ADDR     =  'd10;
  localparam  FB0_ADDR 	 	    =  'd11;
  localparam  FB1_ADDR	    	=  'd12;
 
  /*----------------------------- Register Map ends ---------------------*/

  /* clock and reset signals*/
  wire clk;
  wire rst;
  wire we_pcm;  

   /* Compare module wires*/
  wire [2*`BUS_WIDTH-1:0] maf_o;
  wire compare_out;
 
  /* PCM inputs from GPIO, will come from PDM */	
  wire [`BUS_WIDTH-1:0] pcm_reg_i;
	//assign pcm_reg_i = io_in[`BUS_WIDTH-1:0];

  /* PCM register output signal*/
  wire [`BUS_WIDTH-1:0] pcm_reg_o;
  /* 32 - bit sign extended pcm value */
  wire [2*`BUS_WIDTH-1:0] pcm32, pcm32abs;
  
  /* clock enable wiring*/
  wire ce;
  /* Multiplier  output */
  wire [2*`BUS_WIDTH-1:0] mul_o;
  
 /** Wishbone Slave Interface **/
  reg wbs_done;
  wire wb_valid;
  wire [3:0] wstrb;

// $$$$ DONDE VA CADA UNO DE ESTOS REG
  reg [`BUS_WIDTH-1:0] control;
  reg [`BUS_WIDTH-1:0] amp;
  reg [`BUS_WIDTH-1:0] pcm;
  reg [`BUS_WIDTH-1:0] pcm_load;
  reg [2*`BUS_WIDTH-1:0] timer;

  //---- IIR COEFF ---- //
  reg [`BUS_WIDTH-1:0] a0;
  reg [`BUS_WIDTH-1:0] a1;
  reg [`BUS_WIDTH-1:0] a2;
  reg [`BUS_WIDTH-1:0] b1;
  reg [`BUS_WIDTH-1:0] b2;
	//---- FIR COEFF ---- //
  reg [`BUS_WIDTH-1:0] fb0;
  reg [`BUS_WIDTH-1:0] fb1;
  reg [2*`BUS_WIDTH-1:0] threshold;
 

  wire iir_valid;
  wire clear;
  wire timer_we;
  wire srlatchQ;
  wire srlatchQbar;
  wire addr_valid;

  reg [2*`BUS_WIDTH-1:0] rdata;

  assign wbs_ack_o = wb_valid_i ? wbs_done : 1'bz;
  assign wbs_dat_o = wb_valid_i ? rdata : 32'bz;
  assign hi_z      = wb_valid_i ? 0 : 1;
  
  assign clk = wb_clk_i;
  assign rst = wb_rst_i;



/* register mapping and slave interface  */

	always@(posedge clk) begin
		if(rst) begin
            wbs_done <= 0;
			a0 <= 0;
			a1 <= 0;
			a2 <= 0;
			b1 <= 0;
			b2 <= 0;
			fb0 <= 0;
			fb1 <= 0;
            amp <= 0;
            threshold <= 0;
            control <= 0;
		    pcm_load <= 0;
            rdata <= 0;

		end
		else begin
            wbs_done <= 0;
			if (wb_valid_i) begin     
				case(wbs_adr_i)   
					CONTROL_ADDR: 
 						begin
                  rdata <= control;
                   		if(wbs_strb_i)
       						      control <= wbs_dat_i;
                      end
					A0_ADDR:
 						begin
                  rdata <= a0;
                   	if(wbs_strb_i)
       						    a0 <= wbs_dat_i;
            end
					A1_ADDR:
 						begin
                  rdata <= a1;
                   	if(wbs_strb_i)
       						    a1 <= wbs_dat_i;
            end
					A2_ADDR:
 						begin
                  rdata <= a2;
                   		if(wbs_strb_i)
       						a2 <= wbs_dat_i;
                        end
					B1_ADDR:
 						begin
                  rdata <= b1;
                   	if(wbs_strb_i)
       						    b1 <= wbs_dat_i;
            end
					B2_ADDR:
 						begin
                  rdata <= b2;
                   		if(wbs_strb_i)
       						      b2 <= wbs_dat_i;
            end
					FB0_ADDR:
 						begin
                   	         rdata <= fb0;
                   		if(wbs_strb_i)
       						fb0 <= wbs_dat_i;
                        end
					FB1_ADDR:
 						begin
                   	         rdata <= fb1;
                   		if(wbs_strb_i)
       						fb1 <= wbs_dat_i;
                        end

					PCM_ADDR:
 						begin
                   	         rdata <= pcm;
                        end
					TIMER_ADDR:
 						begin
                   	         rdata <= timer;
                        end
					PCM_LOAD_ADDR:
 						begin
                   	         rdata <= pcm_load;
                   		if(wbs_strb_i)
       						 pcm_load <= wbs_dat_i;
                        end
					AMP_ADDR:
 						begin
                   	         rdata <= amp;
                   		if(wbs_strb_i)
       						amp <= wbs_dat_i;
                        end
					THRESHOLD_ADDR:
 						begin
                   	         rdata <= threshold;
                   		if(wbs_strb_i)
       						threshold <= wbs_dat_i;
                        end
                    default: begin  rdata <= 0; end
				endcase
                wbs_done  <= 1;
			end
		end
   end 
  
/* pcm register block */
  always@(posedge clk) begin
  	if(rst) 
		pcm <= 0;
    else if (we_pcm)
        pcm <= pcm_load;
  end

/* timer register block */
/*-----------------------------------------------------------------------------*/
  always @(posedge clk)
    begin
      if (rst)
            timer <= 0;
        else if (clear)
            timer <= 0;
        else if (timer_we)
            timer <= timer + 1'b1;
    end

assign  clear  = mclear;
assign  timer_we = we_pcm & (srlatchQbar); 
/*-----------------------------------------------------------------------------*/


assign we_pcm = control[1] ? control[2] : ce_pcm; 


  /*-------------------------Structural modelling ----------------------------*/
  
  /*------------------------  PDM starts   -----------------------------------*/
  //../..//rtl/top.v:176: warning: Port 3 (prescaler) of pcm_clk expects 10 bits, got 8.

  wire mic_in;
  assign mic_in = pdm_data_i;

  wire [`BUS_WIDTH-1:0] cic_out;

  RSS0  cicmodule(clk, rst, mclk, mic_in, cic_out);

  /*------------------------   PDM ends    -----------------------------------*/
  
  /*------------------------   FIR start    -----------------------------------*/
  
  wire [`BUS_WIDTH-1:0] fir_out;
  FIR_Filter fir_filter(clk, rst, we_pcm, cic_out, fb0, fb1, fir_out);
  
  /*------------------------   FIR ends    -----------------------------------*/
  
  /*------------------------  PCM starts   -----------------------------------*/
  
  assign pcm_reg_i = control[4] ? pcm_load :fir_out;
  assign pcm_reg_o = pcm;
  
  /*------------------------   PCM ends    -----------------------------------*/
  
  /*------------------------   SE starts    -----------------------------------*/
  signext se(pcm_reg_o, pcm32);
  /*------------------------   SE ends    -----------------------------------*/
  
  /*------------------------  MUL starts   -----------------------------------*/
	wire [2*`BUS_WIDTH-1:0] mul_i;
	wire [2*`BUS_WIDTH-1:0]iir_data;
	assign mul_i = control[3] ? pcm32 : iir_data; 

  MULTI mul(mul_i, amp, mul_o);
  /*------------------------   MUL ends    -----------------------------------*/
  
  
  /*------------------------  ABS starts   -----------------------------------*/
  Abs  abs(mul_o, pcm32abs);
  /*------------------------   ABS ends    -----------------------------------*/
  
  /*------------------------  IIR starts   -----------------------------------*/
	IIR_Filter u_Filter(
    .clk(clk),
    .rst(rst),
    .en(we_pcm),
    .X(pcm_reg_o),
    .a0(a0),
    .a1(a1),
    .a2(a2),
    .b1(b1),
    .b2(b2),
    .valid(iir_valid),
    .Y(iir_data)
		);
  /*------------------------   IIR ends    -----------------------------------*/
  
  /*------------------------  MAMOV starts   ---------------------------------*/
  MAF_FILTER maf(clk, rst, we_pcm, pcm32abs, maf_o);
  /*------------------------   MAMOV ends    ---------------------------------*/
  
  /*------------------------  COMP starts   ----------------------------------*/
  
  comparator comp(maf_o, threshold, compare_out);
  
  SR_latch sr(clk, rst, clear, compare_out, srlatchQ, srlatchQbar);
  assign cmp = srlatchQ;
  
  /*------------------------   COMP ends    ----------------------------------*/
  
endmodule

