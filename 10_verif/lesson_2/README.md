# отчет прохождения заданий 2 урока

## 01_pow

1. нужно было сгенерить тактовый сигнал
2. задать его период
3. через итерацию задавать аргумент порядком итерации
4. задать рандомно несколько значений - четных
5. задать несколько значений делящихся на 3 используя генерацию пока не %3==0;

## 02_riscv

  в этом задании надо задавать команду и потом соответственно спекам risc v проверять константы выуженные из этих команд (модуль данный нам изначально содержит ошибку)

1.  задаем рандомное 32 битное число, как команду
2.  сохраняем число в пакетное поле instr и константы полученные по факту с предыдущей инструкции
3.  сверяем их
4.  получаем такие ошибки (небольшая вырезка из которой видно, что ошибка в модуле парса везде кроме i - константы) и главное видно что перепутаны S и  B

    ```tcl
   Time: 45 ns  Iteration: 1  Process: /testbench_riscv/Initial99_6  Scope: testbench_riscv.Block99_7  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_2/02_riscv/testbench_riscv.sv Line: 120
   Error: Bad B-imm extraction: got 1115 (0000045b), exp 3162 (00000c5a)
   Time: 45 ns  Iteration: 1  Process: /testbench_riscv/Initial99_6  Scope: testbench_riscv.Block99_7  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_2/02_riscv/testbench_riscv.sv Line: 126
   Error: Bad U-imm extraction: got 581853184 (22ae6000), exp 1163706368 (455cc000)
   Time: 45 ns  Iteration: 1  Process: /testbench_riscv/Initial99_6  Scope: testbench_riscv.Block99_7  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_2/02_riscv/testbench_riscv.sv Line: 132
   Error: Bad J-imm extraction: got 13108 (00003334), exp 838740 (000ccc54)
   Time: 45 ns  Iteration: 1  Process: /testbench_riscv/Initial99_6  Scope: testbench_riscv.Block99_7  File: C:/Users/glkru/internship2/Internship/10_verif/lesson_2/02_riscv/testbench_riscv.sv Line: 138
   Error: Bad S-imm extraction: got 3162 (00000c5a), exp 1115 (0000045b)
    ```
5. меняем в парсере s и  b местами и теперь ошибки только у j и u

У этих двух строк в парсере ошибка:

```sv
assign u_imm_w = { instr[31:12], { ( 11 ){ 1'b0 } } };
assign j_imm_w = { { ( 20 ){ instr[31] } }, instr[19:12], instr[20], instr[24:21], 1'b0 };
```

должно быть:
```sv
assign u_imm_w = { instr[31:20], instr[19:12],  { ( 12 ){ 1'b0 } } };
assign j_imm_w = { { ( 11 ){ instr[31] } }, instr[19:12], instr[20], instr[30:21], 1'b0 };
```

**теперь все отлично проходится**
