package require openlane

set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag user_project_wrapper -overwrite

set save_path $script_dir/res

run_synthesis
init_floorplan
#gen_pdn
place_io



add_macro_placement TopSoC 210 210 N

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
                
