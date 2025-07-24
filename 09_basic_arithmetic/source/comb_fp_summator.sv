import struct_types::*;


typedef enum {
  OK         = 1'b0,
  NAN_or_INF = 1'b1
} num_status;

module sequence_fp_summator (
  input  float_point_num a_i,
  input  float_point_num b_i,
  input  logic           vld_i,


  output logic           answer_status,
  output float_point_num answer_0
);

  float_point_num a_l, b_l;

  always_comb begin : fetch
    a_l = '{sign : a_i.sign, exp : a_i.exp, mant : ({1'b1, a_i.mant})};

    b_l = '{sign : b_i.sign, exp : b_i.exp, mant : ({1'b1, b_i.mant})};
  end


  logic           num_status;

  always_comb begin : status
    if(((&a_i.exp) == 'b1) || ((&b_i.exp) == 'b1))
      num_status = 1'b0;
    else
      num_status = 1'b1;
  end

 logic       larger_exp;
 logic [7:0] exp_dif;

  always_comb begin : get_exp_diff
    larger_exp = a_l.exp > b_l.exp;
    if(larger_exp)
      exp_dif = a_l.exp - b_l.exp;
    else
      exp_dif = b_l.exp - a_l.exp;
  end


  always_comb begin : mant_shift
    if(larger_exp) begin
      b_l.mant = b_l.mant >> exp;
      b_l.exp  = a_l.exp;
    end else begin
      a_l.mant = a_l.mant >> exp;
      a_l.exp  = b_l.exp;
    end
  end


  logic [24:0] mant_sum;
  logic        res_sign;


  always_comb begin : mant_sum
    if(a_l.sign = b_l.sign) begin
      mant_sum = {1'b0, a_l.mant} + {1'b0, b_l.mant};
      res_sign = a_l.sign;
    end else begin
      if(a_l.sign)begin
        mant_sum = {1'b0, b_l.mant} - {1'b0, a_l.mant};
        res_sign = a_l.mant > b_l.mant;
      end else begin
         mant_sum = {1'b0, a_l.mant} - {1'b0, b_l.mant};
         res_sign = b_l.mant > a_l.mant;
      end
    end
  end




endmodule
