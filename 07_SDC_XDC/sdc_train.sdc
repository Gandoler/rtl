
##############################Clocks:#########################

# 1.	Тактовая частота clk составляет 333 (3) МГц. 
#(Все входы и выходы запускаются/перехватываются одними и теми же тактовыми импульсами 
#- для ввода-вывода виртуальные тактовые импульсы не требуются) 
create_clock -name clk1 -period 3 [get_ports clk]



# 2.	Максимальная задержка генератора тактовых импульсов (который находится за пределами MY_DESIGN) 
#на порту clk составляет 700 ps. (HINT: source latency)

set_clock_latency 0.7 -source  [get_clocks clk1]

#3.	Максимальная задержка от порта синхронизации ко всем пинам clk регистров составляет 300 +/-30 ps   
# https://www.intel.com/content/www/us/en/docs/programmable/683068/18-1/set-clock-latency-set-clock-latency.html
#Error (332000): Following required options are missing: -source
#---------------------------------------------------------------------------

#Usage: set_clock_latency [-h] [-help] [-long_help] [-clock <clock_list>] [-early] [-fall] [-late] [-rise] -source <delay> <targets>

#set_clock_latency 0.3 -fall  [all_clocks]



# 4.	Период синхронизации может варьироваться в следствии jitter = 40ps


# 5.	50+50

set_clock_uncertainty 0.090 -setup  -to [get_clocks clk1]


# 6.	Наихудшее время переключения любого тактового сигнала составляет 120 ps

#Error (332000): Unknown option: -rise
#
#    while executing
#"set_clock_transition -rise 0.12 [get_clocks clk1]"
#    (file "SDC1.sdc" line 34)
#
#set_clock_transition -rise 0.12 [get_clocks clk1]

#set_clock_transition -max 0.12 [get_clocks clk1]


#7.	Предположим, что максимальное время setup для любого регистра в 
# MY_DESIGN составляет 0,2нс

# You can also increase the value to account for
# additional margin for setup/hold time checks

#set_clock_uncertainty -setup 0.2 [get_clocks clk]

# ??? - но стоит ли это добавлять если уже заложен запас в 0,5 нс

##############################Входы:#########################


# 1.	Максимальная задержка от портов data1 и data2 до внутренней логики ввода составляет 2,2нс. 

set_input_delay  -max 2.2  -clock clk1 [get_ports {data1 data2}]

# 2.	Самое позднее абсолютное время поступления данных от F3 на порт sel составляет 1,4нс 
# (задержка ввода задается с учетом фактического расположения launch edge) 
set_input_delay  -max  1.4  -clock clk1 [get_ports sel]


##############################Выходы:#########################

# 1.	Максимальная задержка внешней комбинированной логики на выходе порта составляет 
# 420 ps; время setup F6 составляет 80 ps. 

set_output_delay -min 0.420 -clock clk [get_ports out1]
set_output_delay -max 0.500 -clock clk [get_ports out1]

#2.	Максимальная внутренняя задержка на выходе out2 составляет 810 ps 
set_output_delay  -max 0.810 -clock clk1 [get_ports out2]

#3.	Для порта out3 требуется обеспечить внешний setup time в 400 ps
set_output_delay  -max 0.400 -clock clk1 [get_ports out3]

##############################Комбинационная :#########################

# 1.	Максимальная задержка от Cin1 и Cin2 до Cout составляет 2,45нс
set_max_delay 2.45 -from [list [get_ports Cin1] [get_ports Cin2]] -to [get_ports Cout]



