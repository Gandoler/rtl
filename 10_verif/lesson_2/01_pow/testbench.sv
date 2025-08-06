`timescale 1ns/1ps

module testbench_riscv;

    logic        clk;
    logic [31:0] A;
    logic [31:0] B;

    pow DUT(
        .clk ( clk ),
        .a   ( A   ),
        .b   ( B   )
    );

    `include "checker.svh"

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 10;// ?;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            // Пишите тут.
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end



    int rand_val;


    initial begin

        logic [31:0] A_tmp;
        // TODO:
        // Сгенерируйте несколько чисел в интервале от 0 до 25.
        // �?спользуйте цикл + @(posedge clk).
        for(int i = 0; i < 26; i++) begin
          A <= i;
          @(posedge clk);
        end


        -> done_100;

        // TODO:
        // Сгенерируйте несколько только четных чисел.
        // �?спользуйте цикл + @(posedge clk).
        // Подумайте, как сделать число четным после рандомизации.
        for(int i = 0; i < 26; i++) begin
          @(posedge clk);
          A <= ($urandom_range(2, 22) << 1);
        end

        -> done_2;

        // TODO:
        // Сгенерируйте несколько чисел чисел, которые делятся на 3
        // без остатка.
        // �?спользуйте цикл + @(posedge clk).
        // Здесь нужно рандомизировать число, пока не выполнится
        // условие деления на 3 без остатка: <число> % 3 == 0.
        for(int i = 0; i < 26; i++) begin
          do begin
            rand_val = $urandom_range(3, 33);
          end
          while(!(rand_val % 3 == 0));
          @(posedge clk);
          A <= rand_val;
        end

        -> done_3;

    end

endmodule
