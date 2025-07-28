`timescale  1ns/1ps


module pipiline_tb import float_types_pkg::*;;

  reg clk;
  reg rst;
  logic [31:0] a_i, b_i, answer_o, res;
  logic vld_i;

  logic   [1:0]    answer_status_o;

   pipilined_fp_summator DUT(
    .clk_i(clk),
    .rst_i(rst),

    .a_i(a_i),
    .b_i(b_i),
    .vld_i(vld_i),

    .num_status_o(answer_status_o),
    .answer_o(answer_o));

    initial 
       clk = 0;
       always #10 clk = ~clk;
       initial begin
         rst = 1;
         #40;
         vld_i =1'b1;
         a_i = {1'b0, 8'b0111_1110, 23'b11000000000000000000000};  //0.875
         b_i = {1'b0, 8'b1000_0000, 23'b00011001100110011001101};    // 2.2
         #50;
         //0	10000000	10001001100110011001101 --RES
         res = {1'b0, 8'b1000_0000, 23'b10001001100110011001101}; // 3.075
           if (answer_o == res) begin
             $display("TEST PASSED: Results match!");
           end else begin
             $display("TEST FAILED: Results do not match!");
           end

    end
  
endmodule
