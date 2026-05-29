create_clock -name clk -period 10 -waveform {0 5} [get_ports clk]

set_clock_transition -rise 0.1 [get_clocks clk]
set_clock_transition -fall 0.1 [get_clocks clk]

# FIX: must reference clock, not port
set_clock_uncertainty 0.01 [get_clocks clk]
set_input_delay -max 1.0 -clock clk [get_ports rst_n]
set_input_delay -max 1.0 -clock clk [get_ports fp_in]

set_output_delay -max 1.0 -clock clk [get_ports decimal_out]

