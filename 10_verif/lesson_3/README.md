# отчет прохождения заданий 3 урока


## 01_pow

1. нужно просто сравнивать tid - чтобы приходил результат той же операции, что мы и кинули
2. проверять что бы данные выходные были равны данным входным в пятой степени

```sv
if( in_p.tid !== out_p.tid ) begin
                $error("%0t Invalid TID: Real: %h, Expected: %h",
                    $time(), out_p.tid, in_p.tid);
            end
            if( out_p.tdata !== in_p.tdata ** 5 ) begin
                $error("%0t Invalid TDATA: Real: %0d, Expected: %0d ^ 5 = %0d",
                    $time(), out_p.tdata, in_p.tdata, in_p.tdata ** 5);
            end
```
3. после запуска теста, получаем ошибки:

```tcl
Time: 255 ns  Iteration: 1  Process: /testbench_01_pow/Initial137_12  Scope: testbench_01_pow.Block137_13  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_3/01_pow/testbench_01_pow.sv Line: 147
Error: Invalid TID: Real: 1, Expected: 0
Time: 275 ns  Iteration: 1  Process: /testbench_01_pow/Initial137_12  Scope: testbench_01_pow.Block137_13  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_3/01_pow/testbench_01_pow.sv Line: 143
Error: Invalid TDATA: Real: 3825766009, Expected: 2120981277 ^ 5 = 3907039405

Time: 275 ns  Iteration: 1  Process: /testbench_01_pow/Initial137_12  Scope: testbench_01_pow.Block137_13  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_3/01_pow/testbench_01_pow.sv Line: 147
Error: Invalid TID: Real: 0, Expected: 1
Time: 295 ns  Iteration: 1  Process: /testbench_01_pow/Initial137_12  Scope: testbench_01_pow.Block137_13  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_3/01_pow/testbench_01_pow.sv Line: 143
Error: Invalid TDATA: Real: 3118512736, Expected: 2337008256 ^ 5 = 0
```

4. Видно что у ошибки цикличность и скорее всего по tid это значит что tid слишком рано выходит. Заходя в модуль пов видно что в for не те числа(отсчет с 1, вместо нуля)

## 02_pow

в этом задании нужно просто поставить задержку на выставление valid передатчика

```sv
    task drive_slave(int delay = 0);
    repeat(delay)
    @(posedge clk);
    m_tready <= 1;
endtask
```
просто в этот таск добавляем задержку


## 03_pow

тут нужно было создать пакетированность передачи данных

> для этого был создан task   `task drive_master_packet(int num_packets)`

```
task drive_master_packet(int num_packets);
    for (int i = 0; i < num_packets; i++) begin
        int delay = $urandom_range(0, 10);     // случайная задержка
        drive_master(delay, (i == num_packets - 1));
    end
    endtask
```

он в цикле n-ое-1 количество раз вызывает `drive_master` с нулем в is_last и на n-ый раз закидывает 1.


## 04_pow

### 1. Это задание заключается в том, что нужно увидеть в чем ошибка и почему его рубит по таймауту, а не по выполнению всех проверок(скорее всего это из-за этой части кода)

```sv
// Slave
    initial begin
        do_slave_drive();
        do_slave_monitor();
    end
```

тут наверное нужно сделать форк\джоин
```sv
// Slave
    initial begin
      fork
        do_slave_drive();
        do_slave_monitor();
      join
    end
```

что бы эти действия выполнялись параллельно


### 2. в процессе выполнения этого задания я столкнулся с очень неприятной ошибкой

```tcl
ERROR: File:  Line: 0 : Invalid X/Z in a state expression value for variable v_2 in an active constraint. If v_2 is intended to be used as a checker as described in LRM1800-2012, 13.10.1, please assign a valid value to state variable. If v_2 is intended to be a random variable, ensure it is declared with 'rand' and the rand_mode has not been turned off.
Time: 0 ps  Iteration: 0  Process: /testbench_04/gen_master/Block91_4/Block91_5
  File: C:/Users/glkru/internship/Internship/10_verif/lesson_3/04_pow/testbench_04.sv
```
>После потраченных 10 минут с Сергеем Андреевичем, было выяснено, что vivado не поддерживает рандомизацию структур через

```sv
 if( !std::randomize(p) with {
                p.delay inside {[0:10]};
                p.tlast == (i == size - 1);
            } ) begin
                $error("Can't randomize packet!");
                $finish();
            end
```

> и пришлось поставить базовое

```sv
  p.delay = $urandom_range(0, 10);
            p.tlast = (i == size - 1);
```

А задание было решено просто добавление форк\джоин
```sv
// Slave
    initial begin
      fork
        do_slave_drive();
        do_slave_monitor();
      join
    end
```


## 05_pow

в этом номере нужно было добавить иерархию передачи параметров

```
// TODO:
    // Реализуйте логику для максимальной и минимальной
    // задержки сигнала tready для slave.
    // Обратите внимание, что в ходе запуска "как есть",
    // тестбенч не скомпилируется из-за несовпадения
    // количества аргументов в задаче slave()
```

это сделать проблем не составило, но я столкнулся с проблемой отсутствия данных и их id, такая же ситуация была пропущена в номере 4

> решение: так как я убрал рандомизацию структуры, и сделал рандомизацию тех полей которые имели ограничения в рандомизации, я забыл про поля которые ее не имеют

```sv
 task gen_master(input int size = 1);
        packet p;
        for(int i = 0; i < size; i = i + 1) begin
            p.delay = $urandom_range(0, 10);
            p.tlast = (i == size - 1);
            /* if( !std::randomize(p) with {
                p.delay inside {[0:10]};
                p.tlast == (i == size - 1);
            } ) begin
                $error("Can't randomize packet!");
                $finish();
            end */
            gen2drv.put(p);
        end
    endtask
```
надо просто добавить это:

```sv
  p.tdata = $urandom();
  p.tid   = $urandom_range(0, 1);
```

## 6 номер - я пропущу, при необходимости - сделаю (постараюсь реализацию сделать в главе pipelines)
