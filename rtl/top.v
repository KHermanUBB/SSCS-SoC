`include "defines.v"

`define MAX_SOC 16
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
    output  wbs_ack_o,
    output  [31:0] wbs_dat_o,

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

  reg [2*`BUS_WIDTH-1:0] status;
  reg [2*`BUS_WIDTH-1:0] rdata;
  reg [2*`BUS_WIDTH-1:0]  prescaler;
  reg  wbs_done;
  wire wb_valid;
  wire [3:0] wstrb;


  wire  [`MAX_SOC-1:0] cmp;
  wire mclear;
  wire mclk;
  wire ce_pcm;
  wire ce_pdm;
  wire addr_valid;


  reg [15:0] valid_i;
  wire  strb_i;
  wire [3:0] adr_i;
  wire [`BUS_WIDTH-1:0] dat_i;
  wire [10:0]  addr;
  
  wire [`BUS_WIDTH-1:0] dat_o[`MAX_SOC-1];
  wire                  ack_o[`MAX_SOC-1];

  reg [`BUS_WIDTH-1:0] wbs_dat;
  reg wbs_ack;


  assign dat_i = {wbs_dat_i[31], wbs_dat_i[14:0]};
  assign addr = ((wbs_adr_i[10:0] >> 2) - 11'd2);
  assign adr_i = addr[3:0];
  assign strb_i = wstrb[0];


  assign wb_valid = wbs_cyc_i && wbs_stb_i; 
  assign wstrb = wbs_sel_i & {4{wbs_we_i}};
  assign addr_valid = (wbs_adr_i[31:28] == 3) ? 1 : 0;
 
  assign irq[0] = |status;
  /*clear send from CARAVEL*/
  assign mclear  = la_data_in[0];
  /*  assign 4.5 MHz clock on GPIO0*/
  assign io_out[0] = mclk;
  assign io_oeb[0] = 1'b1;


  always@(addr  or wb_valid or addr_valid) begin

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
				 'd11:  begin  valid_i[11] <= 1'b1; end 
				 'd12:  begin  valid_i[12] <= 1'b1; end 
				 'd13:  begin  valid_i[13] <= 1'b1; end 
				 'd14:  begin  valid_i[14] <= 1'b1; end 
                  default: begin valid_i <= 0 ;  end
		endcase
    end
    else 
      valid_i <= 0;
  end



  always@(valid_i   or dat_o[0] or dat_o[1] or dat_o[2] or dat_o[3] or dat_o[4] or dat_o[5] or dat_o[6] or dat_o[7] or dat_o[8] or dat_o[9] or dat_o[10] or dat_o[11] or dat_o[12] or dat_o[13] or dat_o[14] 
                    or ack_o[0] or ack_o[1] or ack_o[2] or ack_o[3] or ack_o[4] or ack_o[5] or ack_o[6] or ack_o[7] or ack_o[8] or ack_o[9] or ack_o[10] or ack_o[11] or ack_o[12] or ack_o[13] or ack_o[14] 
                  ) begin
        case(valid_i)   
				 'h1     :  begin 
							wbs_dat <=  dat_o[0];
							wbs_ack <=  ack_o[0];
                            end
				 'h2     :  begin 
							wbs_dat <=  dat_o[1];
							wbs_ack <=  ack_o[1];
                            end
				 'h4     :  begin 
							wbs_dat <=  dat_o[2];
							wbs_ack <=  ack_o[2];
                            end
				 'h8     :  begin 
							wbs_dat <=  dat_o[3];
							wbs_ack <=  ack_o[3];
                            end
				 'h10    :  begin 
							wbs_dat <=  dat_o[4];
							wbs_ack <=  ack_o[4];
                            end
				 'h20    :  begin 
							wbs_dat <=  dat_o[5];
							wbs_ack <=  ack_o[5];
                            end
				 'h40    :  begin 
							wbs_dat <=  dat_o[6];
							wbs_ack <=  ack_o[6];
                            end 
				 'h80    :  begin 
							wbs_dat <=  dat_o[7];
							wbs_ack <=  ack_o[7];
                            end 
				 'h100   :  begin 
							wbs_dat <=  dat_o[8];
							wbs_ack <=  ack_o[8];
                            end 
				 'h200   :  begin 
							wbs_dat <=  dat_o[9];
							wbs_ack <=  ack_o[9];
                            end 
				 'h400   :  begin 
							wbs_dat <=  dat_o[10];
							wbs_ack <=  ack_o[10];
                            end 
				 'h800   :  begin 
							wbs_dat <=  dat_o[11];
							wbs_ack <=  ack_o[11];
                            end 
				 'h1000  :  begin 
							wbs_dat <=  dat_o[12];
							wbs_ack <=  ack_o[12];
                            end 
				 'h2000  :  begin 
							wbs_dat <=  dat_o[13];
							wbs_ack <=  ack_o[13];
                            end
				 'h4000  :  begin 
							wbs_dat <=  dat_o[14];
							wbs_ack <=  ack_o[14];
                            end 

                  default: begin 
							wbs_dat <=  0;
							wbs_ack <=  0;
                           end
		endcase
  end

assign wbs_dat_o =   (valid_i != 0)  ? {{16{wbs_dat[15]}},wbs_dat} : rdata;
assign wbs_ack_o =   (valid_i != 0)  ? wbs_ack                     : wbs_done;




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
          status[`MAX_SOC-1:0] <= cmp;
    end


/*  ----------------------  STRUCTURAL DESIGN BEGINS ----------------------- */

micclk  mic(
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .mclk(mclk),
        .ce_pdm(ce_pdm)
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
    .wbs_ack_o(ack_o[0]),
    .wbs_dat_o(dat_o[0]),
    
    .ce_pdm(ce_pdm),
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
    .wbs_ack_o(ack_o[1]),
    .wbs_dat_o(dat_o[1]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[2]),
    .mclear(mclear),
    .cmp(cmp[1])
	);

SonarOnChip   soc3(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[2]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[2]),
    .wbs_dat_o(dat_o[2]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[3]),
    .mclear(mclear),
    .cmp(cmp[2])
	);

SonarOnChip   soc4(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[3]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[3]),
    .wbs_dat_o(dat_o[3]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[4]),
    .mclear(mclear),
    .cmp(cmp[3])
	);

SonarOnChip   soc5(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[4]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[4]),
    .wbs_dat_o(dat_o[4]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[5]),
    .mclear(mclear),
    .cmp(cmp[4])
	);

SonarOnChip   soc6(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[5]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[5]),
    .wbs_dat_o(dat_o[5]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[6]),
    .mclear(mclear),
    .cmp(cmp[5])
	);

SonarOnChip   soc7(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[6]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[6]),
    .wbs_dat_o(dat_o[6]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[7]),
    .mclear(mclear),
    .cmp(cmp[6])
	);

SonarOnChip   soc8(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[7]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[7]),
    .wbs_dat_o(dat_o[7]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[8]),
    .mclear(mclear),
    .cmp(cmp[7])
	);

SonarOnChip   soc9(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[8]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[8]),
    .wbs_dat_o(dat_o[8]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[9]),
    .mclear(mclear),
    .cmp(cmp[8])
	);

SonarOnChip   soc10(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[9]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[9]),
    .wbs_dat_o(dat_o[9]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[10]),
    .mclear(mclear),
    .cmp(cmp[9])
	);

SonarOnChip   soc11(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[10]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[10]),
    .wbs_dat_o(dat_o[10]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[11]),
    .mclear(mclear),
    .cmp(cmp[10])
	);

SonarOnChip   soc12(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[11]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[11]),
    .wbs_dat_o(dat_o[11]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[12]),
    .mclear(mclear),
    .cmp(cmp[11])
	);

SonarOnChip   soc13(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[12]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[12]),
    .wbs_dat_o(dat_o[12]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[13]),
    .mclear(mclear),
    .cmp(cmp[12])
	);


SonarOnChip   soc14(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[13]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[13]),
    .wbs_dat_o(dat_o[13]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[14]),
    .mclear(mclear),
    .cmp(cmp[13])
	);

SonarOnChip   soc15(

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[14]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o[14]),
    .wbs_dat_o(dat_o[14]),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[15]),
    .mclear(mclear),
    .cmp(cmp[14])
	);
/*
SonarOnChip   soc16(
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[15]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o),
    .wbs_dat_o(dat_o),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[16]),
    .mclear(mclear),
    .cmp(cmp[15])
	);
SonarOnChip   soc17(
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_valid_i(valid_i[16]),
    .wbs_adr_i(adr_i),
    .wbs_dat_i(dat_i),
    .wbs_strb_i(strb_i),
    .wbs_ack_o(ack_o),
    .wbs_dat_o(dat_o),
    
    .ce_pdm(ce_pdm),
    .ce_pcm(ce_pcm),
    .pdm_data_i(io_in[17]),
    .mclear(mclear),
    .cmp(cmp[16])
	);
*/

/*  ----------------------  STRUCTURAL DESIGN ENDS ------------------------- */

endmodule
