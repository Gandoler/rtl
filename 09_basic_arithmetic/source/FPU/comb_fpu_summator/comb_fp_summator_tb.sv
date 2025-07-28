`timescale  1ns/1ps

module tb_fp_adder;
import float_types_pkg::*;

  float_point_num a_i, b_i;
  logic vld_i;
  float_point_num answer_o;
  float_point_num res;
  logic   [1:0]    answer_status_o;

  comb_fp_summator UUT(.a_i(a_i), .b_i(b_i), .vld_i(vld_i),
                           .answer_status_o(answer_status_o), .answer_o(answer_o));

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
    #10
      vld_i =1'b1;
      a_i = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000};  // 1
      b_i = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000};  // 1
      #1;
      //0	10000000	10001001100110011001101 --RES
      res = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00000000000000000000000}; // 2
      
       if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
      $display("TEST PASSED: Results match!");
    end else begin
      $display("TEST FAILED: Results do not match!");
    end
    #10
    
      vld_i =1'b1;
      a_i = '{sign : 1'b0, exp :8'b1000_0000, mant : 23'b00000000000000000000000};  // 2
      b_i = '{sign : 1'b1, exp :8'b0111_1111, mant : 23'b00000000000000000000000};  // -1
      #2;
      //0	10000000	10001001100110011001101 --RES
      res = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000}; // 1
     
    
       if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
      $display("TEST PASSED: Results match!");
    end else begin
      $display("TEST FAILED: Results do not match!");
    end
    #10
    
    vld_i =1'b1;
      a_i = '{sign : 1'b0, exp :8'b01111110, mant : 23'b10000000000000000000000};  // 0.75
      b_i = '{sign : 1'b0, exp :8'b01111101, mant : 23'b00000000000000000000000};  // 0.25
      #2;
      //0	10000000	10001001100110011001101 --RES
      res = '{sign : 1'b0, exp :8'b01111111, mant : 23'b00000000000000000000000}; // 1
     
    
       if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
      $display("TEST PASSED: Results match!");
    end else begin
      $display("TEST FAILED: Results do not match!");
    end
    #10
    
     vld_i =1'b1;
      a_i = '{sign : 1'b0, exp :8'b10000001, mant : 23'b01110000000000000000000};  // 5.75
      b_i = '{sign : 1'b1, exp :8'b10000001, mant : 23'b01110000000000000000000};  // -5.75
      #2;
      //0	10000000	10001001100110011001101 --RES
      res = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0
     
    
       if (answer_o.sign == res.sign && answer_o.exp == res.exp && answer_o.mant == res.mant) begin
      $display("TEST PASSED: Results match!");
    end else begin
      $display("TEST FAILED: Results do not match!");
    end
    #10
    
    
     vld_i =1'b1;
      a_i = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0  
      b_i = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0  
      #2;
      //0	10000000	10001001100110011001101 --RES
      res = '{sign : 1'b0, exp :8'b00000000, mant : 23'b00000000000000000000000}; // 0
     
    
       if (answer_status_o == ZERO_res) begin
      $display("TEST PASSED: Results match!");
    end else begin
      $display("TEST FAILED: Results do not match!");
    end
    #10
    
    $finish;
  end
endmodule
