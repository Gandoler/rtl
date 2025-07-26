module mant_shif_stage import float_types_pkg::*; (
  input  float_point_num a_i,
  input  float_point_num b_i,

  output float_point_num a_o,
  output float_point_num b_o,
);

  always_comb begin : get_exp_diff
    larger_exp = a_i.exp > b_i.exp;
    if(larger_exp)
      exp_dif = a_i.exp - b_i.exp;
    else
      exp_dif = b_i.exp - a_i.exp;
  end

  float_point_num a_l, b_l;

  always_comb begin : mant_shiftt
    b_l = b_i;
    a_l = a_i;
    if(larger_exp)
      b_l  = '{sign : b_i.sign, exp :  a_i.exp, mant : ( b_i.mant >> exp_dif)};
    else
      a_l = '{sign : a_i.sign, exp :  b_i.exp, mant : (a_i.mant >> exp_dif)};
  end

  assign a_o = a_l;
  assign b_o = b_l;

endmodule
