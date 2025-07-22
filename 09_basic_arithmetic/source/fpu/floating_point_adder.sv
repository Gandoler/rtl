`include "struct_types.sv"
import float_struct::*;

 typedef enum logic[1:0]{
    OK  = 2'b00,
    NAN = 2'b01,
    INF = 2'b10,
    NUL = 2'b11
  } states;


module floating_point_adder (
    input               clk,
    input               rst,

    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        arg_vld,

    output logic [31:0] result,
    output logic [1:0]  state,
    output logic        res_vld
);

  logic           en;
  float_point_num pipelined_input1;
  float_point_num pipelined_input2;
  float_point_num pipelined_num1 [0 : 6-1];
  float_point_num pipelined_num2 [0 : 6-1];

  shift_reg_for_struct shift_reg_for_struct_1#(
  STAGES = 6;
)(
  .clk(clk),
  .rst(rst),
  .en(en),
  .in_data(pipelined_input1),
  .out_data(pipelined_num1)
);

shift_reg_for_struct shift_reg_for_struct_2#(
  STAGES = 6;
)(
  .clk(clk),
  .rst(rst),
  .en(en),
  .in_data(pipelined_input1),
  .out_data(pipelined_num2)
);


   always_ff @( posedge clk ) begin // fetch
    if (rst) begin
      pipelined_input1.sign <= 'b0;
      pipelined_input1.exp  <= 'b0;
      pipelined_input1.mant <= 'b0;

      pipelined_input2.sign <= 'b0;
      pipelined_input2.exp  <= 'b0;
      pipelined_input2.mant <= 'b0;
    end else if(arg_vld) begin
      pipelined_input1.sign = a[31];
      pipelined_input1.exp = a[30:23];
      pipelined_input1.mant = a[22:0];

      pipelined_input2.sign = b[31];
      pipelined_input2.exp = b[30:23];
      pipelined_input2.mant = b[22:0];
    end
  end

  always_ff @( posedge clk ) begin
    if(rst)
      en <= 'b0;
    else if(!((&pipelined_input1.exp) == 'b1))
      en <= 'b1;
  end

  always_comb begin

    if()

  end




endmodule
