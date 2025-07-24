
module tb_fp_adder;
import struct_types::*;

  float_point_num a_i, b_i;
  logic vld_i = 1;
  float_point_num answer_o;

  comb_fp_summator UUT(.a_i(a_i), .b_i(b_i), .vld_i(vld_i),
                           .answer_status_o(), .answer_o(answer_o));

  initial begin

      a_i = '{sign : 1'b0, exp :8'b01111110, mant : 23'b11000000000000000000000};  //0.875
      b_i = '{sign : 1'b0, exp :8'b10000000, mant : 23'b00011001100110011001101};    // 2.2
      #1;


     
    $finish;
  end
endmodule
