module fetch_stage import float_types_pkg::*;(
  input  logic           valid_i,
  input  float_point_num a_i,
  input  float_point_num b_i,

  output float_point_num a_o,
  output float_point_num b_o,
  output logic           num_status
);

always_comb begin
  if (valid_i) begin
    a_o     = '{sign: a_i.sign, exp: a_i.exp, mant : ({1'b1, a_i.mant})};

    b_o     = '{sign: b_i.sign, exp: b_i.exp, mant : ({1'b1, b_i.mant})};
  end else begin
    a_o = a_i;
    b_o = b_i;
  end
end

always_comb begin
 if(((&a_i.exp) == 1'b1) || ((&b_i.exp) == 1'b1))
   num_status = 1'b0;
 else
    num_status = 1'b1;
end



endmodule
