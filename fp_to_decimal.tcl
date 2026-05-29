
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
set_db init_hdl_search_path /home/student/22BEC1016_NEW/work

read_libs slow.lib
read_hdl fp_to_decimal.v

# Explicitly set top
elaborate fp_to_decimal
current_design fp_to_decimal



set_db syn_generic_effort medium
syn_generic

set_db syn_map_effort medium
syn_map

set_db syn_opt_effort medium
syn_opt

report_area   > fp_to_decimal_area_report.rpt
report_timing > fp_to_decimal_timing_report.rpt
report_power  > fp_to_decimal_power_report.rpt

write_hdl -mapped fp_to_decimal_synthesized.v
write_sdf fp_to_decimal_synthesized.sdf
write_sdf -timescale ns fp_to_decimal_synthesized.sdf

