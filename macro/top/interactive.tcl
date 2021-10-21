package require openlane

set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag topSoC -overwrite

set save_path $script_dir/res

run_synthesis
init_floorplan
#gen_pdn
place_io

add_macro_placement soc1   100 20 N
add_macro_placement soc2   100 190 N
add_macro_placement soc3   100 360 N
add_macro_placement soc4   100 530 N
add_macro_placement soc5   100 700 N
add_macro_placement soc6   100 870 N
add_macro_placement soc7   100 1040 N
add_macro_placement soc8   100 1210 N
add_macro_placement soc9   100 1380 N
add_macro_placement soc10  100 1550 N
add_macro_placement soc11  100 1720 N
add_macro_placement soc12  100 1890 N
add_macro_placement soc13  100 2060 N
add_macro_placement soc14  100 2230 N
add_macro_placement soc15  100 2400 N
add_macro_placement soc16  100 2570 N
add_macro_placement soc17  100 2740 N
add_macro_placement soc18  100 2910 N

add_macro_placement soc19   1400 20 S
add_macro_placement soc20   1400 190 S
add_macro_placement soc21   1400 360 S
add_macro_placement soc22   1400 530 S
add_macro_placement soc23   1400 700 S
add_macro_placement soc24   1400 870 S
add_macro_placement soc25   1400 1040 S
add_macro_placement soc26   1400 1210 S
add_macro_placement soc27   1400 1380 S
add_macro_placement soc28  1400 1550 S
add_macro_placement soc29  1400 1720 S
add_macro_placement soc30  1400 1890 S
add_macro_placement soc31  1400 2060 S
add_macro_placement soc32  1400 2230 S
add_macro_placement soc33  1400 2400 S
add_macro_placement soc34  1400 2570 S
add_macro_placement soc35  1400 2740 S
add_macro_placement soc36  1400 2910 S


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
