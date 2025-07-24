import float_types_pkg::*;


typedef enum {
  OK_state         = 1'b0,
  NAN_or_INF = 1'b1
} num_status;

module sequence_fp_summator (
  input  float_point_num a_i,
  input  float_point_num b_i,
  input  logic           vld_i,


  output logic           answer_status_o,
  output float_point_num answer_o
);

  float_point_num a_l, b_l;

  always_comb begin : fetch
    a_l = '{sign : a_i.sign, exp : a_i.exp, mant : ({1'b1, a_i.mant})};

    b_l = '{sign : b_i.sign, exp : b_i.exp, mant : ({1'b1, b_i.mant})};
  end


  logic           num_status;

  always_comb begin : status
    if(((&a_i.exp) == 'b1) || ((&b_i.exp) == 'b1))
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

  always_comb begin : mant_shift
    if(larger_exp)
      new_b  = '{sign : b_l.sign, exp :  a_l.exp, mant : ( b_l.mant >> exp_dif)};
    else
      new_a = '{sign : a_l.sign, exp :  b_l.exp, mant : (a_l.mant >> exp_dif)};
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
    if(mant_sum[24]) begin
      answer = '{sign : res_sign, exp : (a_l.exp + 1), mant : mant_sum[23:1]};
      denormilize = 1'b0;
    end else if (mant_sum[23]) begin
      answer = '{sign : res_sign, exp : a_l.exp, mant : mant_sum[22:0]};
      denormilize = 1'b0;
    end else begin
      answer = '{sign : 'b0, exp : 'b0, mant : 'b0};
      denormilize = 1'b1;
    end
  end

  logic found_1;
  logic [7:0] new_exp;

  always_comb begin : denormilize_case
    found_1 = 1'b0;
    if(denormilize) begin
      for(int i = 22; i >= 0; i--)begin
        if(mant_sum[i] && (!found_1)) begin
          new_exp  <= a_l.exp - (22 - i + 1);
          mant_sum <= mant_sum << (22 - i);
          found_1                <= 'b1;
        end
      end


      if(found_1) begin
        answer = '{sign : res_sign, exp : new_exp , mant : mant_sum[22:0]};
      end else
        answer.sign   <= 'b0;
    end
  end


assign answer_o = '{sign : answer.sign, exp : answer.exp, mant : answer.mant};


endmodule
