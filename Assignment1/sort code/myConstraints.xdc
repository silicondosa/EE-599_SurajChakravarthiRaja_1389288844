create_clock -period 10.000 [get_ports clk]
create_clock -period 10.000 -name clk -add [get_ports clk]

set_operating_conditions -grade extended
