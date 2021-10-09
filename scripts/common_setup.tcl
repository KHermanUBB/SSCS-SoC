set RESULTS_DIR ./results
set SKY130_PATH $env(PDK_ROOT)
file mkdir $RESULTS_DIR
set RTL_FILES [glob -directory ../rtl/ *.v]
#set INCLUDE_DIR ../rtl/include
set DESIGN_NAME SonarOnChip


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
