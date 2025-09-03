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
