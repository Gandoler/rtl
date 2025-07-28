`timescale  1ns/1ps


module pipiline_tb;

  reg clk;
  reg rst;
  float_point_num a_i, b_i;
  logic vld_i;
  float_point_num answer_o;
  float_point_num res;
  logic   [1:0]    answer_status_o;

   pipilined_fp_summator DUT(
    .clk_i(clk),
    .rst(rst_i),

    .a_i(a_i),
    .b_i(b_i),
    .vld_i(vld_i),

    .num_status_o(answer_status_o),
    .answer_o(answer_o));

    initial begin
       always #10 clk = ~clk;
       rst = 1;
       #40;
       vld_i =1'b1;
       a_i = '{sign : 1'b0, exp :8'b0111_1110, mant : 23'b11000000000000000000000};  //0.875
       b_i = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00011001100110011001101};    // 2.2
       #50;
       //0	10000000	10001001100110011001101 --RES
       res = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b10001001100110011001101}; // 3.075


    end
endmodule
