`timescale  1ns/1ps


module pipiline_tb import float_types_pkg::*;;

  reg clk;
  reg rst;
  float_point_num a_i, b_i;
  logic vld_i;
  float_point_num answer_o;
  float_point_num res;
  logic   [1:0]    answer_status_o;

   pipilined_fp_summator DUT(
    .clk_i(clk),
    .rst_i(rst_i),

    .a_i(a_i),
    .b_i(b_i),
    .vld_i(vld_i),

    .num_status_o(answer_status_o),
    .answer_o(answer_o));

    initial
       clk = 0;
       always #5 clk = ~clk;
       initial begin
         rst = 1;
         #40;
         rst = 0;
         vld_i =1'b1;
         a_i = '{sign : 1'b0, exp :8'b0111_1110, mant : 23'b11000000000000000000000};  //0.875
         b_i = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00011001100110011001101};    // 2.2
         #10;

         vld_i =1'b1;
         a_i = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000};  // 1
         b_i = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000};  // 1
         #10
         vld_i =1'b1;
         a_i = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00000000000000000000000};  // 2
         b_i = '{sign : 1'b1, exp :8'b0111_1111, mant : 23'b00000000000000000000000};  // -1
         #10
         vld_i =1'b1;
         a_i = '{sign : 1'b0, exp :8'b01111110, mant : 23'b10000000000000000000000};  // 0.75
         b_i  = '{sign : 1'b0, exp :8'b01111101, mant : 23'b00000000000000000000000};  // 0.25
         #10
         vld_i =1'b1;
         a_i = '{sign : 1'b0, exp :8'b10000001, mant : 23'b01110000000000000000000};  // 5.75
         b_i = '{sign : 1'b1, exp :8'b10000001, mant : 23'b01110000000000000000000};  // -5.75

         //0	10000000	10001001100110011001101 --RES
         res = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b10001001100110011001101}; // 3.075
         if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
           $display("TEST PASSED: Results match!");
         end else begin
           $display("TEST FAILED: Results do not match!");
         end
         #10


         res = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00000000000000000000000}; // 2
         if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
          $display("TEST PASSED: Results match!");
         end else begin
          $display("TEST FAILED: Results do not match!");
         end
         #10

         res = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000}; // 1
         if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
           $display("TEST PASSED: Results match!");
         end else begin
           $display("TEST FAILED: Results do not match!");
         end
         #10


         res = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000}; // 1
         if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
           $display("TEST PASSED: Results match!");
         end else begin
           $display("TEST FAILED: Results do not match!");
         end


         vld_i =1'b0;
         #40
         vld_i =1'b1;
         a_i = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0
         b_i = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0
         #40


          res = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0
         if (answer_status_o == ZERO_res) begin
           $display("TEST PASSED: Results match!");
         end else begin
           $display("TEST FAILED: Results do not match!");
         end




      $finish;
    end

endmodule
