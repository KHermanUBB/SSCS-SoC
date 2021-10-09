/*

Testbench for SonarOnChip module
Author K. Herman
Date: 30.05.2021
kherman@ubiobio.cl

*/
//--------------------------------------------------
module SonarOnChip_behavioral_tb;
/*------------------------------------------------*/
  reg wb_clk_i;
  reg wb_rst_i;
  reg wbs_stb_i;
  reg wbs_cyc_i;
  reg wbs_we_i;
  reg [3:0] wbs_sel_i;
  reg [31:0] wbs_dat_i;
  reg [31:0] wbs_adr_i;
  reg [15:0] pcm;
  wire wbs_ack_o;
  wire [31:0] wbs_dat_o;

  // Logic Analyzer Signals
  reg  [127:0] la_data_in;
  wire [127:0] la_data_out;
  reg  [127:0] la_oenb;

    // IOs
  reg  [`MPRJ_IO_PADS-1:0] io_in;
  wire [`MPRJ_IO_PADS-1:0] io_out;
  wire [`MPRJ_IO_PADS-1:0] io_oeb;

    // IRQ
  wire [2:0] irq;
/*------------------------------------------------*/
  
  SonarOnChip soc(
    wb_clk_i, 
    wb_rst_i, 
    wbs_stb_i,
    wbs_cyc_i,
    wbs_we_i,
    wbs_sel_i,
    wbs_dat_i,
    wbs_adr_i,
    wbs_ack_o,
    wbs_dat_o,
    la_data_in,
    la_data_out,
    la_oenb,
    io_in,
    io_out,
    io_oeb,
    irq,
    pcm);
  
/* clock signal generation*/  
initial begin
  wb_clk_i=0;
  forever #10 wb_clk_i = ~wb_clk_i;  
end 
 /* stimuls */ 
initial begin
  
  wb_rst_i = 0;
  la_data_in[0] = 1;
  pcm = 0;
  #20
  wb_rst_i = 1;
  #20 
  wb_rst_i = 0;
  
  #20 pcm = 23;
  #20 pcm = -456;
  #20 pcm = 78;
  #20 pcm = -28998;
               
  #200 $finish;
end
/* Monitor and dump */  
initial begin
  $monitor ("%t  clk = %d rst = %d ", $time, wb_clk_i, wb_rst_i);
    $dumpfile("dump.vcd");
    $dumpvars();
end
endmodule
