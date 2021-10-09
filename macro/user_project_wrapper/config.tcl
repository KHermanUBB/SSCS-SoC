# User config
set ::env(DESIGN_NAME) user_project_wrapper

# section begin
set script_dir [file dirname [file normalize [info script]]]

# Change if needed
set ::env(VERILOG_FILES) "$script_dir/src/user_project_wrapper.v"

# Fill this
set ::env(CLOCK_PERIOD) "40.0"
set ::env(CLOCK_PORT) "wb_clk_i"

set ::env(DIE_AREA) "0 0 2920 3520"
## Internal Macros
### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/macro/top.v \
	$script_dir/macro/defines.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../TopSoC/res/lef/topSoC.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../TopSoC/res/gds/topSoC.gds"

source $script_dir/fixed_wrapper_cfgs.tcl


set ::env(FP_CORE_UTIL) 35
set ::env(FP_PDN_VOFFSET) 0
set ::env(FP_PDN_VPITCH) 30

set ::env(GLB_RT_MAXLAYER) 5

set ::env(FP_PDN_CHECK_NODES) 0

set ::env(DESIGN_IS_CORE) 0
set ::env(SYNTH_STRATEGY) "AREA 0" 


set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}











