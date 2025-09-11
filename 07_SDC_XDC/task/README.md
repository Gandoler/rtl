# отчет по созданию sdc

## Clocks
### 1.	Тактовая частота clk составляет 333 (3) МГц.
>1.	Тактовая частота clk составляет 333 (3) МГц. (Все входы и выходы запускаются/перехватываются одними и теми же тактовыми импульсами - для ввода-вывода виртуальные тактовые импульсы не требуются)

```TCL
create_clock -name clk1 -period 3.0 [get_ports clk]
```

### 2.	Максимальная задержка генератора тактовых импульсов (который находится за пределами MY_DESIGN)
на порту clk составляет 700 ps. (HINT: source latency)
>2.	Максимальная задержка генератора тактовых импульсов (который находится за пределами MY_DESIGN) на порту clk составляет 700 ps. (HINT: source latency)

```TCL
set_clock_latency 0.7 -source  [get_clocks clk1]
```

### 3.	Максимальная задержка от порта синхронизации ко всем пинам clk регистров составляет 300 +/-30 ps
>Note: The Timing Analyzer automatically computes network latencies; therefore, you only can characterize source latency with the set_clock_latency command. You must use the -source option.

эта строчка взята с [intel support](https://www.intel.com/content/www/us/en/docs/programmable/683068/18-1/set-clock-latency-set-clock-latency.html) и как я понимаю мы не можем вручную задавать задержку от порта синх. до пинов

так бы можно было бы добавить что-то типа:
```TCL
set_clock_latency  -rise 0.27 [get_clocks clk1]
set_clock_latency  -fall  0.33 [get_clocks clk1]
```
### 4.	Период синхронизации может варьироваться в следствии jitter = 40ps
> тут можно объединить его с 5 пунктом и сразу добавить до 40+50=90
```TCL
set_clock_uncertainty 0.090 -setup  -to [get_clocks clk1]
```
### 5. Примените к периоду синхронизации “проектный запас" в 50 ps
> смотреть пункт 4

### 6.	Наихудшее время переключения любого тактового сигнала составляет 120 ps

> я не совсем понял почему, но для хоть какого-то задания перехода получилось использовать только команду
```TCL
set_input_transition 0.12 [get_ports clk1]
```
> т.к. команду `set_clock_transition  0.12 -min [get_clocks clk1]` он не признает

### 7.	Предположим, что максимальное время setup для любого регистра в MY_DESIGN составляет 0,2нс

>ну это вроде беспроблемно делать этой командой
```TCL
set_clock_uncertainty 0.20 -setup -to [get_clocks clk1]
```
## Inputs

### 1.	Максимальная задержка от портов data1 и data2 до внутренней логики ввода составляет 2,2нс.

> тут простая команда, но что бы синтезатор не ругался добавляю еще минимум на нуле
```TCL
set_input_delay -clock clk1 -max 2.2   [get_ports {data1 data2}]
set_input_delay -clock clk1 -min 0.000 [get_ports {data1 data2}]
```

### 2.	Самое позднее абсолютное время поступления данных от F3 на порт sel составляет 1,4нс (задержка ввода задается с учетом фактического расположения launch edge)

```TCL
set_input_delay -clock clk1 -max  1.4  [get_ports sel]
set_input_delay -clock clk1 -min 0.000 [get_ports sel]
```
> бонус, чтобы отчёт не ругался на unconstrained inputs у портов Cin1/Cin2, зададим им нулевые задержки.
```TCL
set_input_delay -clock clk1 -max 0.000 [get_ports {Cin1 Cin2}]
set_input_delay -clock clk1 -min 0.000 [get_ports {Cin1 Cin2}]
```
## Outputs

### 1. Максимальная задержка внешней комбинированной логики на выходе порта составляет 420 ps; время setup F6 составляет 80 ps.
