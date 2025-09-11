module sum_stage import float_types_pkg::*;(
  input  float_point_num a_i,
  input  float_point_num b_i,

  output logic [24:0]    res_mant_o,
  output logic           res_sign_o

);

  logic [24:0] mant_sum;
  logic        res_sign;


  always_comb begin : mant_plus_or_minus
    if(a_i.sign == b_i.sign) begin
      mant_sum = {1'b0, a_i.mant} + {1'b0, b_i.mant};
      res_sign = a_i.sign;
    end else begin
      if(a_i.sign)begin
        mant_sum = {1'b0, b_i.mant} - {1'b0, a_i.mant};
        res_sign = a_i.mant > b_i.mant;
      end else begin
         mant_sum = {1'b0, a_i.mant} - {1'b0, b_i.mant};
         res_sign = b_i.mant > a_i.mant;
      end
    end
  end


  assign res_mant_o = mant_sum;
  assign res_sign_o = res_sign;

endmodule
