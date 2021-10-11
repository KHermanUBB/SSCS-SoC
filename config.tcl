set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) SonarOnChip

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) "40"
set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "wb_clk_i"
set ::env(FP_SIZING) absolute
#set ::env(DIE_AREA) "0 0 2920 3520"
set ::env(DIE_AREA) "0 0 1000 165"
set ::env(DESIGN_IS_CORE) 0
set ::env(PL_SKIP_INITIAL_PLACEMENT) 
set ::env(PL_TARGET_DENSITY) 0.58
#set ::env(FP_ASPECT_RATIO) 0.3571
set ::env(FP_CORE_UTIL) 60
set ::env(GLB_RT_ALLOW_CONGESTION) 1
set ::env(SYNTH_STRATEGY) "AREA 0"
#set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 4

set ::env(CTS_TOLERANCE) 100
set ::env(CTS_REPORT_TIMING) 1

set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PIN_ORDER_CFG) "$script_dir/pin_order.cfg" 

#set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 5
#set ::env(BASE_SDC_FILE) $::env(OPENLANE_ROOT)/designs/SonarOnChip/src/sonarOnChip.sdc

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}
