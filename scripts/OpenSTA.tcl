# --------------------------------- PREPARE -------------------------------------------------------
echo on
set RESULTS_DIR ../results/OpenSTA
set SKY130_PATH $env(PDK_ROOT)
 #set RTL_FILES [glob -directory ../rtl/ *.v]
#set INCLUDE_DIR ../rtl/include
set DESIGN_NAME SonarOnChip
set LIB_FILE ${SKY130_PATH}/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib

set_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm
# --------------------------------- PREPARE -------------------------------------------------------

# --------------------------------- GLOABAL -------------------------------------------------------
read_liberty $LIB_FILE
read_verilog SonarOnChip.v



link_design SonarOnChip
#read_spef SonarOnChip.spef
set_timing_derate -early 0.9
set_timing_derate -late  1.1
create_clock -name wb_clk_i -period 40 {wb_clk_i }
set_clock_uncertainty -setup 0.5  [get_clocks wb_clk_i]
set_clock_uncertainty -hold 0.5   [get_clocks wb_clk_i]
set_clock_transition 0.1          [get_clocks wb_clk_i]
# --------------------------------- GLOABAL -------------------------------------------------------


# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------
set_input_delay -clock wb_clk_i 0.5  [get_ports pdm_data_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wb_rst_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wb_rst_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_stb_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_cyc_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_we_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_sel_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_dat_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_adr_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports mclk]
set_input_delay -clock wb_clk_i 0.5  [get_ports ce_pcm]
set_input_delay -clock wb_clk_i 0.5  [get_ports mclear]


set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wb_rst_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_stb_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_cyc_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_we_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_sel_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_dat_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_adr_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports mclk]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports ce_pcm]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports mclear]


set_output_delay -clock wb_clk_i 0.5 [get_ports wbs_ack_o*]
set_output_delay -clock wb_clk_i 0.5 [get_ports wbs_dat_o*]
set_output_delay -clock wb_clk_i 0.5 [get_ports cmp]

set_load 0.1 [get_ports wbs_ack_o*]
set_load 0.1 [get_ports wbs_dat_o*]
set_load 0.1 [get_ports cmp]
# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------


# --------------------------------- REPORTS BEGINS --------------------------------------------------------
report_checks -path_delay min_max                                    > $RESULTS_DIR/$DESIGN_NAME.check.rpt
report_clock_skew -setup   -clock [get_clocks wb_clk_i]  -digits 6   > $RESULTS_DIR/$DESIGN_NAME.skew.setup.rpt
report_clock_skew -hold    -clock [get_clocks wb_clk_i]  -digits 6   > $RESULTS_DIR/$DESIGN_NAME.skew.hold.rpt
# --------------------------------- REPORTS ENDS --------------------------------------------------------

