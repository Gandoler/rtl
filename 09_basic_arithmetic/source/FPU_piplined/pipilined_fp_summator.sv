module pipilined_fp_summator import float_types_pkg::*; (
  input logic clk,
  input logic rst,

  input loigc [31:0] a_i,
  input loigc [31:0] b_i,
  input loigc vld_i,

  output logic [31:0] answer_o,
  output logc  [1:0]  num_status_o
);

  float_point_num a_o, b_o;
  logic [1:0]     state_o;

  fetch_stage fetch_stage(
    .valid_i(vld_i),
    .a_i(a_i),
    .b_i(b_i),

    .a_o(a_o),
    .b_o(b_o),
    .num_status(state_o)
  );

  float_point_num a_fetch, b_fetch;
  logic [1:0]     state;
//todo state to shift reg

  always_ff @( posedge clk ) begin : fetch_stage_reg
    if(rst) begin
      a_fetch <= '{sign : 'b0, exp : 'b0, mant : 'b0};
    end else begin
      a_fetch <= a_o;
      b_fetch <= b_o;
    end
  end

  float_point_num a_o_shift, b_o_shift;

  mant_shif_stage mant_shif_stage(
    .a_i(a_fetch),
    .b_i(b_fetch),

    .a_o(a_o_shift),
    .b_o(b_o_shift),
  );


  float_point_num a_shift, b_shift;
  always_ff @( posedge clk ) begin : mant_shif_stage
    if(rst) begin
      a_shift <= '{sign : 'b0, exp : 'b0, mant : 'b0};
      b_shift <= '{sign : 'b0, exp : 'b0, mant : 'b0};
    end else begin
      a_shift <= a_o_shift;
      b_shift <= b_o_shift;
    eng

  end


  logic [24;0] res_mant_o
  logic res_sign_o;
  sum_stage sum_stage(
   .a_i(a_shift),
   .b_i(b_shift),

   .res_mant_o(res_mant_o),
   .res_sign_o(res_sign_o)
  );


  logic [24;0] res_mant
  logic res_sign;
  logic [7:0] a_i_exp;

  always_ff @( posedge clk ) begin : sum_stage
    if(rst) begin
      res_mant <= 'b0;
      res_sign <= 'b0;
      a_i_exp  <= 'b0;
    end else begin
      res_mant <= res_mant_o;
      res_sign <= res_sign;
      a_i_exp  <= a_shift.exp;
    end
   end



  float_point_num answer_o;
  logic           denormilize_state_o;


  sum_shift_stage sum_shift_stage(

  .res_mant_i(res_mant),
  .res_sign_i(res_sign),
  .a_i_exp(a_i_exp),

  .answer_o(answer_o),
  .denormilize_state_o(denormilize_state_o)
  );


  float_point_num answer_o_normilize;
  normilize_stage normilize_stage(

  .res_mant_i(res_mant),
  .res_sign_i(res_sign),
  .a_i_exp(a_i_exp),

  .answer_o(answer_o_normilize)
  );


  float_point_num answer;

  always_ff @( posedge clk ) begin : sum_stage
    if(rst) begin
      answer <= '{sign : 'b0, exp : 'b0, mant : 'b0};
    end else begin
      answer <= denormilize_state_o? answer_o_normilize : answer_o;
    end
  end


assign answer_o = answer;

endmodule
