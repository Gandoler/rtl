import float_types_pkg::*;




module comb_fp_summator (
  input  float_point_num a_i,
  input  float_point_num b_i,
  input  logic           vld_i,


  output logic   [1:0]    answer_status_o,
  output float_point_num answer_o
);

  float_point_num a_l, b_l;

  always_comb begin : fetch
    a_l = '{sign : a_i.sign, exp : a_i.exp, mant : ({1'b1, a_i.mant[22:0]})};

    b_l = '{sign : b_i.sign, exp : b_i.exp, mant : ({1'b1, b_i.mant[22:0]})};
  end


  logic   [1:0]     num_status;

  always_comb begin : status
    if((a_i.mant == 'b0) && (b_i.mant == 'b0) && (a_i.exp == 'b0) && (b_i.exp == 'b0))
        num_status = ZERO_res;
    else if(((&a_i.exp) == 'b1) || ((&b_i.exp) == 'b1))
      num_status = NAN_or_INF;
    else
      num_status = OK_state;
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

  float_point_num new_a, new_b;

  always_comb begin : mant_shiftt
    new_b = b_l;
    new_a = a_l;
    if(larger_exp)
      new_b  = '{sign : new_b.sign, exp :  new_a.exp, mant : ( new_b.mant >> exp_dif)};
    else
      new_a = '{sign : new_a.sign, exp :  new_b.exp, mant : (new_a.mant >> exp_dif)};
  end


  logic [24:0] mant_sum;
  logic        res_sign;


  always_comb begin : mant_plus_or_minus
    if(new_a.sign == new_b.sign) begin
      mant_sum = {1'b0, new_a.mant} + {1'b0, new_b.mant};
      res_sign = new_a.sign;
    end else begin
      if(new_a.sign)begin
        mant_sum = {1'b0, new_b.mant} - {1'b0, new_a.mant};
        res_sign = new_a.mant > new_b.mant;
      end else begin
         mant_sum = {1'b0, new_a.mant} - {1'b0, new_b.mant};
         res_sign = new_b.mant > new_a.mant;
      end
    end
  end

   float_point_num answer;


    logic denormilize;
  always_comb begin : get_res
    answer  = '{sign : 'b0, exp : 'b0, mant : 'b0};
    if(mant_sum[24]) begin
      answer = '{sign : res_sign, exp : (new_a.exp + 1), mant : mant_sum[23:1]};
      denormilize = 1'b0;
    end else if (mant_sum[23]) begin
      answer = '{sign : res_sign, exp : new_a.exp, mant : mant_sum[22:0]};
      denormilize = 1'b0;
    end else begin
      denormilize = 1'b1;
    end
  end

  logic found_1;
  logic [7:0] new_exp;
  logic [25:0] mant_shift;
  float_point_num answer_normilize;

  always_comb begin : denormilize_case
    answer_normilize = '{sign : 'b0, exp : 'b0, mant : 'b0};
    mant_shift = mant_sum;
    found_1 = 1'b0;
    if(denormilize) begin
      for(int i = 23; i >= 20; i--)begin
        if(mant_shift[i] && (!found_1)) begin
          new_exp  = new_a.exp - (22 - i + 1);
          mant_shift = mant_shift << (22 - i);
          found_1                = 1'b1;
        end
      end


      if(found_1) begin
        answer_normilize = '{sign : res_sign, exp : new_exp , mant : mant_shift[21:0]};
      end else
        answer_normilize.sign   <= 'b0;
    end
  end


assign answer_o = denormilize? answer_normilize : answer;
assign answer_status_o = num_status;

endmodule
