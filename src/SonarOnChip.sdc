set_units -time ns
create_clock -name wb_clk_i -period 40 {wb_clk_i }
set_timing_derate -early 0.9
set_timing_derate -late  1.1
set_clock_uncertainty -setup 0.5  [get_clocks wb_clk_i]
set_clock_uncertainty -hold 0.5   [get_clocks wb_clk_i]
set_clock_transition 0.1          [get_clocks wb_clk_i]
# --------------------------------- GLOABAL -------------------------------------------------------

# --------------------------------- GENERATED CLOCK ------------------------------------------------

create_generated_clock -name pdm_clk -source wb_clk_i -divide_by 5  ce_pdm
create_generated_clock -name pcm_clk -source wb_clk_i -divide_by 50 ce_pcm

#set_multicycle_path  50 -setup -from fir_out -to fpcm_reg_i




# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------
set_input_delay -clock wb_clk_i 0.5  [get_ports pdm_data_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wb_rst_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wb_valid_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_strb_i]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_dat_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports wbs_adr_i*]
set_input_delay -clock wb_clk_i 0.5  [get_ports ce_pdm]
set_input_delay -clock wb_clk_i 0.5  [get_ports ce_pcm]
set_input_delay -clock wb_clk_i 0.5  [get_ports mclear]


set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports pdm_data_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wb_rst_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wb_valid_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_strb_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_dat_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_adr_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports ce_pdm]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports ce_pcm]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports mclear]


set_output_delay -clock wb_clk_i 0.5 [get_ports wbs_ack_o*]
set_output_delay -clock wb_clk_i 0.5 [get_ports wbs_dat_o*]
set_output_delay -clock wb_clk_i 0.5 [get_ports cmp]


set_load 0.01 [get_ports wbs_ack_o*]
set_load 0.01 [get_ports wbs_dat_o*]
set_load 0.01 [get_ports cmp]

# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------


# --------------------------------- REPORTS BEGINS --------------------------------------------------------
#report_checks -path_delay min_max                                    > $RESULTS_DIR/$DESIGN_NAME.check.rpt
#report_clock_skew -setup   -clock [get_clocks wb_clk_i]  -digits 6   > $RESULTS_DIR/$DESIGN_NAME.skew.setup.rpt#
#report_clock_skew -hold    -clock [get_clocks wb_clk_i]  -digits 6   > $RESULTS_DIR/$DESIGN_NAME.skew.hold.rpt
