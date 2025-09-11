module fetch_stage import float_types_pkg::*;(
  input  logic           valid_i,
  input  float_point_num a_i,
  input  float_point_num b_i,

  output float_point_num a_o,
  output float_point_num b_o,
  output logic [1:0]     num_status
);

  float_point_num a_l , b_l;

  always_comb begin
    if (valid_i) begin
      a_l = '{sign : a_i.sign, exp : a_i.exp, mant : ({1'b1, a_i.mant[22:0]})};

      b_l = '{sign : b_i.sign, exp : b_i.exp, mant : ({1'b1, b_i.mant[22:0]})};
    end else begin
      a_l = a_i;
      b_l = b_i;
    end
  end

  always_comb begin
   if((a_i.mant == 'b0) && (b_i.mant == 'b0) && (a_i.exp == 'b0) && (b_i.exp == 'b0))
          num_status = ZERO_res;
      else if(((&a_i.exp) == 'b1) || ((&b_i.exp) == 'b1))
        num_status = INF_OR_NAN;
      else
        num_status = OK_state;
  end

  assign a_o = a_l;
  assign b_o = b_l;


endmodule
