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

 logic

  always_comb begin : get_exp_diff



  end





endmodule
