# Synthesis script
yosys -import
echo on
set RESULTS_DIR ./results
set SKY130_PATH $env(PDK_ROOT)
file mkdir $RESULTS_DIR
#set INCLUDE_DIR ../rtl/include
set DESIGN_NAME optFIR_Filter


set LIB_FILES {}
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ff_100C_1v65.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ff_100C_1v95.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ff_n40C_1v56.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ff_n40C_1v65.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ff_n40C_1v76.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ff_n40C_1v95.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_100C_1v40.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_100C_1v60.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_n40C_1v28.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_n40C_1v35.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_n40C_1v40.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_n40C_1v44.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_n40C_1v60.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__ss_n40C_1v76.lib"
append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib"
#append LIB_FILES " ${SKY130_PATH}/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_100C_1v80.lib"

set LIB_FILE ${SKY130_PATH}/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib



read_verilog optFIR.v
#hierarchy -check -top $TOP_MODULE
synth -top $DESIGN_NAME
#share -aggressive
opt
opt_clean -purge
dfflibmap -liberty $LIB_FILE
abc -liberty $LIB_FILE
#hilomap -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
#setundef -zero
#splitnets
#opt_clean -purge
insbuf -buf sky130_fd_sc_hd__buf_2 A X
stat
write_verilog ${RESULTS_DIR}/${DESIGN_NAME}.synth.v
#yosys json -o synth.json
