
`include "defines.v"

`define MAX_SOC 12
`define BUS_WIDTH 16 

module top (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // User maskable interrupt signals
    output [2:0] irq
);

  localparam  STATUS_ADDR	    =  'd0; 
  localparam  PRE_ADDR 			=  'd1; 

  reg [`BUS_WIDTH-1:0] status;
  reg [31:0] rdata;
  reg [7:0]  prescaler;
  reg  wbs_done;
  wire wb_valid;
  wire [3:0] wstrb;


  wire  [1:0] cmp;
  wire mclear;
  wire mclk;
  wire ce_pcm;
  wire addr_valid;


  reg [`MAX_SOC-1:0] valid_i;
  wire  strb_i;
  wire [3:0] adr_i;
  wire [`BUS_WIDTH-1:0] dat_i;
  wire [`BUS_WIDTH-1:0] dat_o;
  wire ack_o;
  wire [10:0]  addr;
  
  assign dat_i = {wbs_dat_i[31], wbs_dat_i[14:0]};
  assign addr = ((wbs_adr_i[10:0] >> 2) - 11'd2);
  assign adr_i = addr[3:0];
  assign strb_i = wstrb[0];

  assign wbs_ack_o = wbs_done;	
  assign wb_valid = wbs_cyc_i && wbs_stb_i; 
  assign wstrb = wbs_sel_i & {4{wbs_we_i}};
  assign addr_valid = (wbs_adr_i[31:28] == 3) ? 1 : 0;
 
  assign irq[0] = |status;
  assign mclear  = la_data_in[0];
  assign io_out[0] = mclk;
  assign io_oeb[0] = 1'b1;


  always@(addr) begin
	
   if (wb_valid && addr_valid)  begin  
        case(addr[8:4])   
				 'd0 :  begin  valid_i[0]  <= 1'b1; end  
				 'd1 :  begin  valid_i[1]  <= 1'b1; end 
				 'd2 :  begin  valid_i[2]  <= 1'b1; end 
				 'd3 :  begin  valid_i[3]  <= 1'b1; end 
				 'd4 :  begin  valid_i[4]  <= 1'b1; end 
				 'd5 :  begin  valid_i[5]  <= 1'b1; end 
				 'd6 :  begin  valid_i[6]  <= 1'b1; end 
				 'd7 :  begin  valid_i[7]  <= 1'b1; end 
				 'd8 :  begin  valid_i[8]  <= 1'b1; end 
				 'd9 :  begin  valid_i[9]  <= 1'b1; end 
				 'd10:  begin  valid_i[10] <= 1'b1; end 
                  default: begin valid_i <= 0 ;  end
		endcase
    end
    else 
      valid_i <= 0;
  end 
wire cond;
assign cond = ((wbs_adr_i[3:2] == 2'b00) || (wbs_adr_i[3:2] == 2'b01 ));
assign wbs_dat_o =  cond ?  rdata       :  {{16{dat_o[15]}},dat_o};
assign wbs_ack_o =  cond ?  wbs_done    :  ack_o;

	always@(posedge wb_clk_i) begin
		if(wb_rst_i) begin
			wbs_done  <= 0;
			status    <= 0;
			prescaler <= 49;
            rdata     <= 0;
		end
		else begin
			wbs_done <= 0;
			if (wb_valid && addr_valid)  begin     
				case(wbs_adr_i[7:2])   
					STATUS_ADDR: 
 						begin	
                   	    	rdata <= status;
						end            
					PRE_ADDR:
 						begin	
                   	        rdata <= prescaler;
                   		if(strb_i)
       						prescaler <= wbs_dat_i;
                        end
                  default: ;
				endcase
 			 wbs_done <= 1; 
			end
            else begin
 		    end        
        end
   end 


/*  write status register */
	always@(posedge wb_clk_i) begin
		if(wb_rst_i) begin
			status  <= 0;
		end 
        else 
          status[1:0] <= cmp;
    end


/*  ----------------------  STRUCTURAL DESIGN BEGINS ----------------------- */

micclk  mic(
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .mclk( mclk)
        );

pcm_clk  pcmclk(
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .prescaler(prescaler),
        .ce_pcm(ce_pcm)
        );
 

SonarOnChip   soc1(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[0]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o),
    .wbs_dat_o(dat_o),
    
    .mclk(mclk),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[1]),
    .mclear(mclear),
    .cmp(cmp[0])
	);

SonarOnChip   soc2(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[1]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o),
    .wbs_dat_o(dat_o),
    
    .mclk(mclk),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[2]),
    .mclear(mclear),
    .cmp(cmp[1])
	);

/*  ----------------------  STRUCTURAL DESIGN ENDS ------------------------- */

endmodule
