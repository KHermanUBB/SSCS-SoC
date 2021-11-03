package require openlane

set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag topSoC -overwrite

set save_path $script_dir/res

run_synthesis
init_floorplan
#gen_pdn
place_io

add_macro_placement soc1   100 20 N
add_macro_placement soc2   100 195 N
add_macro_placement soc3   100 370 N
add_macro_placement soc4   100 545 N
add_macro_placement soc5   100 720 N
add_macro_placement soc6   100 895 N
add_macro_placement soc7   100 1070 N
add_macro_placement soc8   100 1245 N
add_macro_placement soc9   100 1420 N
add_macro_placement soc10  100 1595 N
add_macro_placement soc11  100 1770 N
add_macro_placement soc12  100 1945 N
add_macro_placement soc13  100 2120 N
add_macro_placement soc14  100 2295 N
add_macro_placement soc15  100 2470 N
add_macro_placement soc16  100 2645 N
add_macro_placement soc17  100 2820 N
add_macro_placement soc18  100 2995 N

add_macro_placement soc19   1400 20 S
add_macro_placement soc20   1400 195 S
add_macro_placement soc21   1400 370 S
add_macro_placement soc22   1400 545 S
add_macro_placement soc23   1400 720 S
add_macro_placement soc24   1400 895 S
add_macro_placement soc25   1400 1070 S
add_macro_placement soc26   1400 1245 S
add_macro_placement soc27   1400 1420 S
add_macro_placement soc28  1400 1595 S
add_macro_placement soc29  1400 1770 S
add_macro_placement soc30  1400 1945 S
add_macro_placement soc31  1400 2120 S
add_macro_placement soc32  1400 2295 S
add_macro_placement soc33  1400 2470 S
add_macro_placement soc34  1400 2645 S
add_macro_placement soc35  1400 2820 S
add_macro_placement soc36  1400 2995 S

manual_macro_placement f

set_def $::env(CURRENT_DEF)
#tap_decap_or
run_placement
#global_routing_or
run_cts
run_routing
write_powered_verilog set_netlist $::env(lvs_result_file_tag).powered.v
run_magic
run_magic_spice_export
save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)
run_magic_drc
run_lvs; # requires run_magic_spice_export
run_antenna_check        
