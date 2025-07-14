`timescale 1ns/1ps

module num_4_tb;

  // Параметры модуля
  parameter w_7_indic = 8;

  // Сигналы для подключения
  logic                  clk_i;
  logic                  arstn_i;
  logic  [w_7_indic-1:0] an_o;
  logic                  ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o;

  // Тактовый генератор: 10нс период (100 МГц)
  always #5 clk_i = ~clk_i;

  // DUT: Design Under Test
  num_4 #(
    .w_7_indic(w_7_indic)
  ) dut (
    .clk_i(clk_i),
    .arstn_i(arstn_i),
    .an_o(an_o),
    .ca_o(ca_o),
    .cb_o(cb_o),
    .cc_o(cc_o),
    .cd_o(cd_o),
    .ce_o(ce_o),
    .cf_o(cf_o),
    .cg_o(cg_o),
    .dp_o(dp_o)
  );

  initial begin
    // Инициализация сигналов
    clk_i   = 0;
    arstn_i = 0;
    // Сброс (active-low) на 50 нс
    #20;
    arstn_i = 1;

    // Имитация работы - 2 миллисекунды (достаточно, чтобы покрутить 7-сегментник)
    #200_000_000;

    $finish;
  end

  // Мониторинг - печатаем выводы на каждом изменении
  always_ff @(posedge clk_i) begin
    $display("Time: %0t | an_o: %b | abcdefg: %b", $time, an_o, 
              {ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o});
  end

endmodule