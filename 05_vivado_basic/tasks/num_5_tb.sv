`timescale 1ns / 1ps

module num_5_tb;

  // Параметры
  parameter w_7_indic = 8;
  parameter w_led     = 16;

  // Входы
  logic clk_i;
  logic arstn_i;
  logic BTNL;
  logic BTNR;

  // Выходы
  logic [w_7_indic-1:0] an_o;
  logic [w_led-1:0]     led_o;
  logic                 ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o;

  // DUT
  num_5 #(
    .w_7_indic(w_7_indic),
    .w_led(w_led)
  ) dut (
    .clk_i(clk_i),
    .arstn_i(arstn_i),
    .BTNL(BTNL),
    .BTNR(BTNR),
    .an_o(an_o),
    .led_o(led_o),
    .ca_o(ca_o),
    .cb_o(cb_o),
    .cc_o(cc_o),
    .cd_o(cd_o),
    .ce_o(ce_o),
    .cf_o(cf_o),
    .cg_o(cg_o),
    .dp_o(dp_o)
  );

  // Clock generator: 10ns period
  always #1 clk_i = ~clk_i;

  // Инициализация и стимулы
  initial begin
    // Начальное состояние
    clk_i    = 0;
    arstn_i  = 0;
    BTNL     = 1;
    BTNR     = 1;

    // Сброс
    #20;
    arstn_i = 1;

    // Ждём немного
    #100000;

    // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;

    // Ждём немного
    #200;
    // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;

    // Ждём немного
    #200;
    // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;
    
     #200;
    // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;

    // Ждём немного
    #200;

    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
 #200;
// Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
     #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
 
   #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
 
   #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
 
     #200;
     // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;
 #200;
 // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;
 #200;
 // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;
 #200;
 // Нажимаем BTNR (ускорение)
    BTNR = 0;
    #20;
    BTNR = 1;

    // Ждём пока пройдут несколько движений змейки
    #1000000;


   #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
    
   #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
    
   #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
    
   #200;
    // Нажимаем BTNL (замедление)
    BTNL = 0;
    #20;
    BTNL = 1;
    // Завершение
    $finish;
  end

endmodule