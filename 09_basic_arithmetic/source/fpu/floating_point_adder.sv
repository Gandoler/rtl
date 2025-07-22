`include "struct_types.sv"
import float_struct::*;

 typedef enum logic[1:0]{
    OK  = 2'b00,
    NAN = 2'b01,
    INF = 2'b10,
    NUL = 2'b11
  } states;


module floating_point_adder #(
  parameter STAGES = 6, WIDTH=1
)(
    input               clk,
    input               rst,

    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        arg_vld,

    output logic [31:0] result,
    output logic [1:0]  state,
    output logic        res_vld
);

  logic                  en;
  logic                  state;

  float_point_num pipelined_num1 [0 : 6-1];
  float_point_num pipelined_num2 [0 : 6-1];

  shift_reg_base #(.STAGES(STAGES), .WIDTH(WIDTH)) shift_reg_base
  (
  .clk(clk),
  .rst(rst),
  .en(en),
  .in_data(state),

  .out_data(res_vld)
);

  shift_reg_for_struct #(.STAGES(STAGES)) shift_reg_for_struct_1

  (
  .clk(clk),
  .rst(rst),
  .en(en),
  .in_data(pipelined_input1),
  .out_data(pipelined_num1)
);

shift_reg_for_struct #(.STAGES(STAGES)) shift_reg_for_struct_2
  (
  .clk(clk),
  .rst(rst),
  .en(en),
  .in_data(pipelined_input1),
  .out_data(pipelined_num2)
);


   always_ff @( posedge clk ) begin // fetch
    if (rst) begin
      ppipelined_input1.sign <= 'b0;
      pipelined_input1.exp   <= 'b0;
      pipelined_input1.mant  <= 'b0;

      pipelined_input2.sign  <= 'b0;
      pipelined_input2.exp   <= 'b0;
      pipelined_input2.mant  <= 'b0;
    end else if(arg_vld) begin
      pipelined_input1.sign  <= a[31];
      pipelined_input1.exp   <= a[30:23];
      pipelined_input1.mant  <= {1'b1, b[22:0]};

      pipelined_input2.sign  <= b[31];
      pipelined_input2.exp   <= b[30:23];
      pipelined_input2.mant  <= {1'b1, b[22:0]};
    end
  end

  always_ff @( posedge clk ) begin // fetch
    if (rst) begin
      state                  <= 1'b0;
    end else begin
      if(((&a[30:23]) == 1) || ((&b[30:23]) == 1))  // if     1 or 2 mant  == 255, --> badstate
        state                <= 1'b0;
      else
        state                <= 1'b1;
    end
  end



  always_ff @( posedge clk ) begin
    if(rst)
      en <= 'b0;
    else if(arg_vld)
      en <= 'b1;
  end


  logic signed  [7:0]    exp_dif;
  logic                  larger_mant;

  always_ff @( posedge clk ) begin // exp compare
    if(rst)
      exp_dif     <=0;
      larger_mant <=0;
    else begin // For optimization, avoid using subtraction after this calc
      larger_mant <=  pipelined_num1[1].exp > pipelined_num2[1].exp
      exp_dif     <= (pipelined_num1[1].exp > pipelined_num2[1].exp) ? (pipelined_num1[1].exp - pipelined_num2[1].exp) : (pipelined_num2[1].exp - pipelined_num1[1].exp);
    end
  end


  always_ff @( posedge clk ) begin // exp shift
    if(larger_mant)
      pipelined_num2[2].mant <= pipelined_num2[2].mant >> exp_dif;
    else
      pipelined_num1[2].mant <= pipelined_num1[2].mant >> exp_dif;
  end

  logic [24:0] mant_sum ;


  always_ff @( posedge clk ) begin // mant + or -
    if(rst)
      mant_sum <= 'b0;
    else begin
      if(pipelined_num1[3].sign == pipelined_num2[3].sign) begin
        mant_sum <= {1'b0, pipelined_num1[3].mant} + {1'b0, pipelined_num2[3].mant}
      end else begin
        if(pipelined_num1[3].mant > pipelined_num2[3].mant) begin
         mant_sum <= {1'b0, pipelined_num1[3].mant} - {1'b0, pipelined_num2[3].mant}
        end


      end
    end
  end





endmodule
