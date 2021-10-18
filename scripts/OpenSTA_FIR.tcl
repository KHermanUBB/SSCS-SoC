# --------------------------------- PREPARE -------------------------------------------------------
echo on
#set_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm
set RESULTS_DIR ./results/
set SKY130_PATH $env(PDK_ROOT)
 #set RTL_FILES [glob -directory ../rtl/ *.v]
#set INCLUDE_DIR ../rtl/include
set DESIGN_NAME FIR
set LIB_FILE ${SKY130_PATH}/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib


# --------------------------------- PREPARE -------------------------------------------------------

# --------------------------------- GLOABAL -------------------------------------------------------
read_liberty $LIB_FILE
read_verilog ../test/results/FIR.synth.v

link_design FIR
#read_spef SonarOnChip.spef
set_timing_derate -early 0.9
set_timing_derate -late  1.1
create_clock -name clk -period 5 {clk }
set_clock_uncertainty -setup 0.5  [get_clocks clk]
set_clock_uncertainty -hold 0.5   [get_clocks clk]
set_clock_transition 0.1          [get_clocks clk]
# --------------------------------- GLOABAL -------------------------------------------------------

#create_generated_clock -name en -source clk -divide_by 4  en

set_multicycle_path 4 -setup  -from [get_ports X_i] -to [get_ports Y_o] -start


# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------
set_input_delay -clock clk 0.5  [get_ports X_i]
set_input_delay -clock clk 0.5  [get_ports rst]
set_input_delay -clock clk 0.5  [get_ports en]
set_input_delay -clock clk 0.5  [get_ports b0]
set_input_delay -clock clk 0.5  [get_ports b1]



set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports X_i]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports rst]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports en]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports b0]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_8  [get_ports b1]

set_output_delay -clock clk 0.5 [get_ports Y_o]
set_load 0.1 [get_ports Y_o]


# --------------------------------- PIN SPECIFIC VALUES----------------------------------------------------


# --------------------------------- REPORTS BEGINS --------------------------------------------------------
report_checks -path_delay min_max                                    > $RESULTS_DIR/$DESIGN_NAME.check.rpt
report_clock_skew -setup   -clock [get_clocks clk]  -digits 6   > $RESULTS_DIR/$DESIGN_NAME.skew.setup.rpt
report_clock_skew -hold    -clock [get_clocks clk]  -digits 6   > $RESULTS_DIR/$DESIGN_NAME.skew.hold.rpt
# --------------------------------- REPORTS ENDS --------------------------------------------------------

