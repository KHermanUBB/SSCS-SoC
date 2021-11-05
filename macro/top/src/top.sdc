set_units -time ns
create_clock -name wb_clk_i -period 40 {wb_clk_i }
set_timing_derate -early 0.9
set_timing_derate -late  1.1
set_clock_uncertainty  0.25 [get_clocks wb_clk_i]
set_clock_transition 0.15         [get_clocks wb_clk_i]
# --------------------------------- GLOABAL -------------------------------------------------------

# --------------------------------- GENERATED CLOCK ------------------------------------------------

#create_generated_clock -name pdm_clk -source wb_clk_i -divide_by 5  ce_pdm
#create_generated_clock -name pcm_clk -source wb_clk_i -divide_by 50 ce_pcm
#set_multicycle_path  5 -setup -from ce_pdm
#set_multicycle_path  50 -setup -from ce_pcm



# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------
# set input delay
#set_input_delay -clock wb_clk_i 2  [get_ports wb_rst_i]
#set_input_delay -clock wb_clk_i 2  [get_ports wb_strb_i]
#set_input_delay -clock wb_clk_i 2  [get_ports wbs_strb_i]
#set_input_delay -clock wb_clk_i 2  [get_ports wbs_dat_i*]
#set_input_delay -clock wb_clk_i 2  [get_ports wbs_adr_i*]
#set_input_delay -clock wb_clk_i 2  [get_ports ce_pdm]
#set_input_delay -clock wb_clk_i 2  [get_ports ce_pcm]
#set_input_delay -clock wb_clk_i 2  [get_ports mclear]

# set input driving cell
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wb_rst_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wb_stb_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wb_vyv_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_we_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_sel_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_dat_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports wbs_adr_i*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports la_data_in*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports la_data_oenb*]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports io_in*]

# set input delay and driving cell for the external inputs of Mega Project Area
 set_input_delay  -clock wb_clk_i                  4   [get_ports io_in*]
 set_driving_cell -lib_cell sky130_fd_sc_hd__einvp_8   [get_ports io_in*]
#
# # set outputa  delays to the Caravel (by default calculated by RCX)
# # set_output_delay -clock wb_clk_i 0.5 [get_ports wbs_ack_o*]
# # set_output_delay -clock wb_clk_i 0.5 [get_ports wbs_dat_o*]
# # set_output_delay -clock wb_clk_i 0.5 [get_ports la_data_out*]
# # set_output_delay -clock wb_clk_i 0.5 [get_ports irq*]
#
# # outputs loads to the Caravel SoC
 set_load 0.035 [get_ports wbs_ack_o*]
 set_load 0.035 [get_ports wbs_dat_o*]
 set_load 0.035 [get_ports la_data_out*]
 set_load 0.035 [get_ports irq*]


# # set outputs delay for the external outputs of Mega Project Area
 set_output_delay -clock wb_clk_i   4 [get_ports io_out*]
 set_output_delay -clock wb_clk_i   1 [get_ports io_oeb*]

# # set load to the capacitance of "sky130_fd_sc_hd__mux2_1"
 set_load 0.035 [get_ports io_out*]
 set_load 0.035 [get_ports io_oeb*]
#

