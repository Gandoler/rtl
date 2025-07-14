`timescale 1ns / 1ps

module num_5_tb;

  // ���������
  parameter w_7_indic = 8;
  parameter w_led     = 16;

  // �����
  logic clk_i;
  logic arstn_i;
  logic BTNL;
  logic BTNR;

  // ������
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

  // ������������� � �������
  initial begin
    // ��������� ���������
    clk_i    = 0;
    arstn_i  = 0;
    BTNL     = 1;
    BTNR     = 1;

    // �����
    #20;
    arstn_i = 1;

    // ��� �������
    #100000;

    // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;

    // ��� �������
    #200;
    // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;

    // ��� �������
    #200;
    // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;
    
     #200;
    // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;

    // ��� �������
    #200;

    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
 #200;
// �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
     #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
 
   #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
 
   #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
 
     #200;
     // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;
 #200;
 // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;
 #200;
 // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;
 #200;
 // �������� BTNR (���������)
    BTNR = 0;
    #20;
    BTNR = 1;

    // ��� ���� ������� ��������� �������� ������
    #1000000;


   #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
    
   #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
    
   #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
    
   #200;
    // �������� BTNL (����������)
    BTNL = 0;
    #20;
    BTNL = 1;
    // ����������
    $finish;
  end

endmodule