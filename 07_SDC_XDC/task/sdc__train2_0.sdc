
##############################Clocks:#########################
#1
create_clock -name clk1 -period 3.0 [get_ports clk]
#2
set_clock_latency 0.7 -source  [get_clocks clk1]
#4
set_clock_uncertainty 0.090 -setup  -to [get_clocks clk1]
#6
set_input_transition 0.12 [get_ports clk1]
#7
set_clock_uncertainty 0.20 -setup -to [get_clocks clk1]

##############################Входы:#########################
# 1.
set_input_delay -clock clk1 -max 2.2   [get_ports {data1 data2}]
set_input_delay -clock clk1 -min 0.000 [get_ports {data1 data2}]
# 2.
set_input_delay -clock clk1 -max  1.4  [get_ports sel]
set_input_delay -clock clk1 -min 0.000 [get_ports sel]
# бонус
set_input_delay -clock clk1 -max 0.000 [get_ports {Cin1 Cin2}]
set_input_delay -clock clk1 -min 0.000 [get_ports {Cin1 Cin2}]

##############################Выходы:#########################

# 1.	Максимальная задержка внешней комбинированной логики на выходе порта составляет
# 420 ps; время setup F6 составляет 80 ps.

set_output_delay -clock clk1 -max 0.500 [get_ports out1]
set_output_delay -clock clk1 -min 0.420 [get_ports out1]

#2.	Максимальная внутренняя задержка на выходе out2 составляет 810 ps
set_output_delay -clock clk1 -max 0.810 [get_ports out2]

#3.	Для порта out3 требуется обеспечить внешний setup time в 400 ps
set_output_delay -clock clk1 -max 0.400 [get_ports out3]
set_output_delay -clock clk1 -min 0.000 [get_ports out3]

# Для Cout — чтобы не было unconstrained output:
set_output_delay -clock clk1 -max 0.000 [get_ports Cout]
set_output_delay -clock clk1 -min 0.000 [get_ports Cout]

##############################Комбинационная :#########################

# 1.	Максимальная задержка от Cin1 и Cin2 до Cout составляет 2,45нс
set_max_delay 2.45 -from [list [get_ports Cin1] [get_ports Cin2]] -to [get_ports Cout]
