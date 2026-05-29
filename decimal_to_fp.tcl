
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
set_db init_hdl_search_path /home/student/22BEC1016_NEW/work

read_libs slow.lib
read_hdl decimal_to_fp.v

# Explicitly set top
elaborate decimal_to_fp
current_design decimal_to_fp



set_db syn_generic_effort medium
syn_generic

set_db syn_map_effort medium
syn_map

set_db syn_opt_effort medium
syn_opt

report_area   > decimal_to_fp_area_report.rpt
report_timing > decimal_to_fp_timing_report.rpt
report_power  > decimal_to_fp_power_report.rpt

write_hdl -mapped decimal_to_fp_synthesized.v
write_sdf decimal_to_fp_synthesized.sdf
write_sdf -timescale ns decimal_to_fp_synthesized.sdf

