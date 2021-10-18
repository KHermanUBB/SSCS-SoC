set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) top

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) "100"
set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "wb_clk_i"
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 7000 7000"
#set ::env(DIE_AREA) "0 0 1000 150"
#set ::env(DIE_AREA) "0 0 1000 800"
set ::env(DESIGN_IS_CORE) 0


set ::env(FILL_INSERTION) 1
set ::env(TAP_DECAP_INSERTION) 1
set ::env(SYNTH_FLAT_TOP) 0
set ::env(SYNTH_NO_FLAT) 1
set ::env(PL_SKIP_INITIAL_PLACEMENT) 
set ::env(PL_TARGET_DENSITY) 0.2
#set ::env(PL_TARGET_DENSITY) 0.4
#set ::env(FP_ASPECT_RATIO) 0.3571
set ::env(FP_CORE_UTIL) 70
set ::env(GLB_RT_ALLOW_CONGESTION) 1
set ::env(SYNTH_STRATEGY) "AREA 0"
#set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5

set ::env(CTS_TOLERANCE) 100
set ::env(CTS_REPORT_TIMING) 1

set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

#set ::env(FP_PIN_ORDER_CFG) "$script_dir/pin_order.cfg" 

#set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 5
#set ::env(BASE_SDC_FILE) "$script_dir/src/SonarOnChip.sdc"

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}
