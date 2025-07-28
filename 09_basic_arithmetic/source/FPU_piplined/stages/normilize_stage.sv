module normilize_stage import float_types_pkg::*;(

  input logic [24:0]     res_mant_i,
  input logic            res_sign_i,
  input logic [7:0]      a_i_exp,

  output float_point_num answer_o
);

 logic found_1;
  logic [7:0] new_exp;
  logic [25:0] mant_shift;
  float_point_num answer_normilize;

  always_comb begin : denormilize_case
    answer_normilize = '{sign : 'b0, exp : 'b0, mant : 'b0};
    mant_shift = res_mant_i;
    found_1 = 1'b0;
    
    for(int i = 23; i >= 20; i--)begin
      if(mant_shift[i] && (!found_1)) begin
        new_exp  = a_i_exp - (22 - i + 1);
        mant_shift = mant_shift << (22 - i);
        found_1                = 1'b1;
    end
    


      if(found_1) begin
        answer_normilize = '{sign : res_sign_i, exp : new_exp , mant : mant_shift[21:0]};
      end else
        answer_normilize.sign   <= 'b0;
    end
  end

  assign  answer_o = answer_normilize;

  endmodule
