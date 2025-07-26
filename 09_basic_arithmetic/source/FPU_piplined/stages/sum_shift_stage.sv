module sum_shift_stage import float_types_pkg::*;(

  input logic [24:0]     res_mant_i,
  input loigc            res_sign_i,
  input logic [7:0]      a_i_exp,

  output float_point_num answer_o,
  output logic           denormilize_state_o

)


  float_point_num answer;


  logic denormilize;
  always_comb begin : get_res
    answer  = '{sign : 'b0, exp : 'b0, mant : 'b0};
    if(mant_sum[24]) begin
      answer = '{sign : res_sign, exp : (a_i_exp + 1), mant : mant_sum[23:1]};
      denormilize = 1'b0;
    end else if (mant_sum[23]) begin
      answer = '{sign : res_sign, exp : a_i_exp, mant : mant_sum[22:0]};
      denormilize = 1'b0;
    end else begin
      denormilize = 1'b1;
    end
  end


  assign answer_o            = answer;
  assign denormilize_state_o = denormilize;

endmodule
