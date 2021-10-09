# Synthesis script
yosys -import
echo on
source ../scripts/common_setup.tcl

#lmap LIB $LIB_FILES { read_liberty -lib -ignore_miss_func $LIB }
lmap RTL $RTL_FILES { read_verilog -I $INCLUDE_DIR $RTL }

#hierarchy -check -top $TOP_MODULE
synth -top $DESIGN_NAME
#share -aggressive
#opt
#opt_clean -purge
dfflibmap -liberty $LIB_FILE
abc -liberty $LIB_FILE
#hilomap -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
#setundef -zero
#splitnets
#opt_clean -purge
insbuf -buf sky130_fd_sc_hd__buf_2 A X

write_verilog ${RESULTS_DIR}/${DESIGN_NAME}.synth.v
#yosys json -o synth.json
