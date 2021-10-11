package require openlane

set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag topSoC -overwrite

set save_path $script_dir/res

run_synthesis
init_floorplan
#gen_pdn
place_io


add_macro_placement soc1 100 50 N
add_macro_placement soc2 100 250 N
add_macro_placement soc3 100 450 N
add_macro_placement soc4 100 650 N
add_macro_placement soc5 100 850 N
add_macro_placement soc6 100 1050 N
add_macro_placement soc7 100 1250 N
add_macro_placement soc8 100 1450 N
add_macro_placement soc9 100 1650 N
add_macro_placement soc10 100 1850 N
add_macro_placement soc11 100 2050 N
add_macro_placement soc12 100 2250 N
add_macro_placement soc13 100 2450 N
add_macro_placement soc14 100 2650 N
add_macro_placement soc15 100 2850 N



manual_macro_placement f


set_def $::env(CURRENT_DEF)

#tap_decap_or

run_placement
#global_routing_or
run_routing
run_magic

run_magic_spice_export

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)
#run_magic_drc
#run_lvs; # requires run_magic_spice_export
#run_antenna_check
     #add_macro_placement soc3  100 360  N
#add_macro_placement soc4  100 540  N
#add_macro_placement soc5  100 720  N
#add_macro_placement soc6  100 900  N
#add_macro_placement soc7  100 1080 N
#add_macro_placement soc8  100 1260 N
#add_macro_placement soc9  100 1440 N
#add_macro_placement soc10 100 1620 N
#add_macro_placement soc11 100 1800 N
#add_macro_placement soc12 100 1980 N
#add_macro_placement soc13 100 2160 N
#add_macro_placement soc14 100 2340 N
#add_macro_placement soc15 100 2520 N
#add_macro_placement soc16 100 2700 N
#add_macro_placement soc17 100 2880 N
#add_macro_placement soc1 100 3060 N           
