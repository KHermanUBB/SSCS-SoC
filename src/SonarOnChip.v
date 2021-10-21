/*
Sonar on Chip top level module based on user project example
Files:
defines.v - macroodefinitions (come vith Caravel)
*/
`include "defines.v"

`define BUS_WIDTH 16 

module SonarOnChip
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
    input wire  ce_pdm,
    /* PCM pace signal */
    input wire  ce_pcm,
    /* External microphone PDM data */
    input wire  pdm_data_i,
    /* Master clear */
    input wire  mclear,
    /* compare otupt signal*/    
    output wire  cmp
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
  wire [`BUS_WIDTH-1:0] maf_o;
  wire compare_out;
  /* PCM inputs from GPIO, will come from PDM */	
  wire [`BUS_WIDTH-1:0] pcm_reg_i;
  /* ABS  output signal*/
  wire [`BUS_WIDTH-1:0] pcm_abs;
  /* Multiplier  output */
  wire [`BUS_WIDTH-1:0] mul_o;
 /** Wishbone Slave Interface **/
  reg wbs_done;
  wire wb_valid;
  wire [3:0] wstrb;
  reg [7:0] control;
  reg [7:0] amp;
  reg signed [`BUS_WIDTH-1:0] pcm;
  reg signed [`BUS_WIDTH-1:0] pcm_load;
  reg [`BUS_WIDTH-1:0] timer;
  //---- IIR COEFF ---- //
  reg signed [`BUS_WIDTH-1:0] a0;
  reg signed [`BUS_WIDTH-1:0] a1;
  reg signed [`BUS_WIDTH-1:0] a2;
  reg signed [`BUS_WIDTH-1:0] b1;
  reg signed [`BUS_WIDTH-1:0] b2;
	//---- FIR COEFF ---- //
  reg signed [`BUS_WIDTH-1:0] fb0;
  reg signed [`BUS_WIDTH-1:0] fb1;
  reg [`BUS_WIDTH-1:0] threshold;
  wire timer_we;
  wire srlatchQ;
  wire srlatchQbar;
  reg [`BUS_WIDTH-1:0] rdata;
  wire [11:0] cic_out;
  wire [`BUS_WIDTH-1:0] fir_out;
  wire [`BUS_WIDTH-1:0] fir_in;
  wire  [`BUS_WIDTH-1:0] mul_i;
  wire  [`BUS_WIDTH-1:0] iir_data;

  assign wbs_ack_o = wbs_done;
  assign wbs_dat_o =  rdata;
  assign clk = wb_clk_i;
  assign rst = wb_rst_i;



/* register mapping and slave interface  */

	always@(posedge clk) begin
		if(rst) begin
        wbs_done <= 0;
		a0 <= 16'h0000;
		a1 <= 16'h0000;
		a2 <= 16'h0000;
		b1 <= 16'h0000;
		b2 <= 16'h0000;
        fb0 <= 0;
        fb1 <= 0;
		fb0 <= 16'h0FFF;
		fb1 <= 16'h7FFF; 
        amp <= 8'h00;
        threshold <= 0;
        control   <= 0; 
        threshold <= 16'h0400;
        control   <= 16'h04; 
		pcm_load <= 16'h0000;
        rdata <= 16'h0000;

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
                    default:   rdata <= 0; 
				endcase
                wbs_done  <= 1;
			end
		end
   end 
  


/* timer register block */
/*-----------------------------------------------------------------------------*/
  always @(posedge clk)
    begin
      if (rst)
            timer <= 0;
        else if (mclear)
            timer <= 0;
        else if (timer_we)
            timer <= timer + 1'b1;
    end
   
   assign  timer_we = we_pcm & (srlatchQbar); 
   /*-----------------------------------------------------------------------------*/

   /* select wheater the PCM clock is derived from main clock or the PCM   
   datapath can be clocked manually*/
  assign we_pcm = ce_pcm; 


  /*-------------------------Structural modelling ----------------------------*/
  
  /*------------------------  PDM starts   -----------------------------------*/
  cic  cicmodule(clk, rst, ce_pdm, pdm_data_i, cic_out);
  /*------------------------   PDM ends    -----------------------------------*/
  
  /*------------------------   FIR start    -----------------------------------*/

 /* extend the 12 bit signal from PDM demodulator to 16 bit*/
  assign fir_in = {{4{cic_out[11]}}, cic_out };
// FIR fir_filter(clk, rst, we_pcm, fir_in, fb0, fb1, fir_out);
  
  /*------------------------   FIR ends    -----------------------------------*/
  
  /*------------------------  PCM starts   -----------------------------------*/
  
  assign pcm_reg_i = control[3] ? pcm_load :fir_out;

/* pcm register block */
  always@(posedge clk) begin
  	if(rst) 
		pcm <= 0;
    else if (we_pcm)
        pcm <= pcm_reg_i;
  end
  /*------------------------   PCM ends    -----------------------------------*/
  
  /*------------------------  MUL starts   -----------------------------------*/
  assign mul_i = control[2] ? pcm : iir_data; 
  multiplier mul(mul_i, amp, mul_o);
  /*------------------------   MUL ends    -----------------------------------*/
    
  /*------------------------  ABS starts   -----------------------------------*/
  Abs  abs(mul_o, pcm_abs);
  /*------------------------   ABS ends    -----------------------------------*/
  
  /*------------------------  IIR starts   -----------------------------------*/
	/*IIR_Filter u_Filter(
    .clk(clk),
    .rst(rst),
    .en(we_pcm),
    .X(pcm),
    .a0(a0),
    .a1(a1),
    .a2(a2),
    .b1(b1),
    .b2(b2),
    .Y(iir_data)
		);
*/

  /*------------------------   IIR ends    -----------------------------------*/
  
  /*------------------------  MAMOV starts   ---------------------------------*/
 //MAF_FILTER maf(clk, rst, we_pcm, pcm_abs, maf_o);
  /*------------------------   MAMOV ends    ---------------------------------*/
  
  /*------------------------  COMP starts   ----------------------------------*/
  
  comparator comp(maf_o, threshold, compare_out);
  SR_latch sr(clk, rst, mclear, compare_out, srlatchQ, srlatchQbar);
  assign cmp = srlatchQ;
  
  /*------------------------   COMP ends    ----------------------------------*/
  


 Filters  filt( .clk(clk),
                .rst(rst),
                .en(we_pcm),
                .X_fir(fir_in),
                .b0_fir(fb0),
                .b1_fir(fb1),
                .Y_fir(fir_out),  
                .X_iir(pcm), 
                .a0_iir(a0),
                .a1_iir(a1), 
                .a2_iir(a2), 
                .b1_iir(b1), 
                .b2_iir(b2), 
                .Y_iir(iir_data),
                .X_maf(pcm_abs),
                .Y_maf(maf_o)
);


endmodule

