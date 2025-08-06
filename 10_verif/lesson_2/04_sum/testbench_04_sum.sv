module testbench_04_sum;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [31:0] A;
    logic [31:0] B;
    logic [31:0] C;

    sum_04 DUT (
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( A       ),
        .b       ( B       ),
        .c       ( C       )
    );

    `include "checker.svh"

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 10; // ?;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;// Пишите тут.
        end
    end

    // Генерация сигнала сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // TODO:
    // Циклически сгенерируйте входные воздействия
    // в соответствии с заданием.

    // В конце симуляции будет выведена статистика о том, какая
    // часть из требуемых значений была подана. Для оценки того,
    // значения из какого интервала не были поданы, воспользуйтесь
    // отчетом 04_sum/stats/covsummary.html (отчет сформируется
    // после закрытия QuestaSim).

    // Для оценки вы также можете воспользоваться файлом
    // 04_sum/out/cov.ucdb

    initial begin
        // Входные воздействия опишите здесь.
        // Не забудьте про ожидание сигнала сброса!


        // TODO:
        // A: от 0 до 100 с шагом  1
        // B: от 100 до 0 с шагом -1
        // �?спользуйте for()
        // Помните про ожидание фронта через @(posedge clk).
        for(int i = 0; i < 100; i++) begin
          @(posedge clk);
          A <= i;
          B <= 100-1-i;
        end

        // TODO:
        // A: от 127 до 255 с шагом 4
        // B: от 127 до 255 с шагом 4
        // �?спользуйте repeat()
        // Помните про ожидание фронта через @(posedge clk).
        A <= 127;
        B <= 127;
        repeat(15) begin
          @(posedge clk);
          A <= A + 4;
          B <= B + 4;
        end

        // TODO:
        // A: от 3FF до 103FE с шагом 5
        // B: от FFFFFFFF до FFFFBFFF с шагом -32
        // �?спользуйте for()
        // Помните про ожидание фронта через @(posedge clk).
        A <= 'h3FF;
        B <= 'hFFFFFFFF;
        for(int a = 'h3FF; a <= 'h103FE;  a = a + 5) begin
          @(posedge clk);
          A <= a;
          B <= B -32;

        end

//        ->> gen_done;

    end

endmodule
