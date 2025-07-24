`timescale  1ns/1ps

module tb_fp_adder;
import float_types_pkg::*;

  float_point_num a_i, b_i;
  logic vld_i;
  float_point_num answer_o;
  float_point_num res;

  comb_fp_summator UUT(.a_i(a_i), .b_i(b_i), .vld_i(vld_i),
                           .answer_status_o(), .answer_o(answer_o));

  initial begin
      vld_i =1'b1;
      a_i = '{sign : 1'b0, exp :8'b0111_1110, mant : 23'b11000000000000000000000};  //0.875
      b_i = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00011001100110011001101};    // 2.2
      #1;
      //0	10000000	10001001100110011001101 --RES
      res = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b10001001100110011001101}; // 3.075
      
      
      
       if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
      $display("TEST PASSED: Results match!");
    end else begin
      $display("TEST FAILED: Results do not match!");
    end
    
    
    $finish;
  end
endmodule
