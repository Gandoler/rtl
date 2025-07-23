`include "struct_types.sv"
import float_struct::*;

 typedef enum logic[1:0]{
    OK  = 2'b00,
    NAN = 2'b01,
    INF = 2'b10,
    NUL = 2'b11
  } states;


module floating_point_adder #(
  parameter STAGES = 6, WIDTH=2
)(
    input                  clk,
    input                  rst,

    input  float_point_num a,
    input  float_point_num b,
    input  logic           arg_vld,

    output float_point_num result,
    output logic   [1:0]   res_state
);

  logic           en;
  logic [1:0]     state;

  float_point_num pipelined_input1;
  float_point_num pipelined_input2;
  
  float_point_num pipelined_num1 [0 : STAGES-1];
  float_point_num pipelined_num2 [0 : STAGES-1];

  shift_reg_base #(.STAGES(STAGES), .WIDTH(WIDTH)) shift_reg_base
  (
  .clk(clk),
  .rst(rst),
  .en(en),
  .in_data(state),

  .out_data(res_state)
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
  .in_data(pipelined_input2),
  .out_data(pipelined_num2)
);


   always_ff @( posedge clk ) begin // fetch
    if (rst) begin
      pipelined_input1      <= '{sign:1'b0, exp:8'b0, mant:23'b0};
      pipelined_input2      <= '{sign:1'b0, exp:8'b0, mant:23'b0};

    end else if(arg_vld) begin
      pipelined_input1.sign  <= a.sign;
      pipelined_input1.exp   <= a.exp;
      pipelined_input1.mant  <= {1'b1, a.mant };

      pipelined_input2.sign  <= b.sign;
      pipelined_input2.exp   <= b.exp;
      pipelined_input2.mant  <= {1'b1, b.mant };
    end
  end

  always_ff @( posedge clk ) begin
    if (rst) begin
      state                  <= 1'b00;
    end else begin
      if(((&a.exp) == 1) || ((&b.exp) == 1))  // if     1 or 2 exp  == 255, --> badstate
        state                <= 2'b10;
      else
        state                <= 2'b11;
    end
  end



  always_ff @( posedge clk ) begin
    if(rst)
      en <= 'b0;
    else if(arg_vld)
      en <= 'b1;
  end


  logic signed  [7:0]    exp_dif;
  logic         [1:0]    larger_mant; // shift reg for transfer result across two clk + optimization

  always_ff @( posedge clk ) begin // exp compare
    if(rst) begin
      exp_dif        <='b0;
      larger_mant    <='b0;
    end else begin // For optimization, avoid using subtraction after this calc
      larger_mant[0] <=  pipelined_num1[1].exp > pipelined_num2[1].exp;
      exp_dif        <= (pipelined_num1[1].exp > pipelined_num2[1].exp) ? (pipelined_num1[1].exp - pipelined_num2[1].exp) : (pipelined_num2[1].exp - pipelined_num1[1].exp);
    end
  end


  always_ff @( posedge clk ) begin // exp shift
    if(larger_mant[0]) begin
      pipelined_num2[2].mant <= pipelined_num2[2].mant >> exp_dif;
      pipelined_num2[2].exp  <= pipelined_num1[2].exp;
    end
    else begin
      pipelined_num1[2].mant <= pipelined_num1[2].mant >> exp_dif;
      pipelined_num1[2].exp  <= pipelined_num2[2].exp;
    end
    larger_mant[1]           <= larger_mant[0];
  end

  logic [24:0] mant_sum ;


  always_ff @( posedge clk ) begin // mant + or -
    if(rst)
      mant_sum                   <= 'b0;
    else begin
      if(pipelined_num1[3].sign == pipelined_num2[3].sign) begin
        mant_sum                 <= {1'b0, pipelined_num1[3].mant} + {1'b0, pipelined_num2[3].mant};
      end else begin
        if(pipelined_num1[3].sign) begin // 1  - minus a
          mant_sum               <= {1'b0, pipelined_num2[3].mant} - {1'b0, pipelined_num1[3].mant}; // b-a
          pipelined_num1[3].sign <= (larger_mant[1])? (1'b1) : (1'b0);
        end else begin
          mant_sum               <= {1'b0, pipelined_num1[3].mant} - {1'b0, pipelined_num2[3].mant}; // b-a
          pipelined_num1[3].sign <= (larger_mant[1])? (1'b0) : (1'b1);
        end
      end
    end
  end

  logic found_1;

  always_ff @( posedge clk ) begin  // normilize
    if(rst)
      found_1                    <= 'b0;
    else if(mant_sum[24]) begin // overflow
      pipelined_num1[4].exp      <= pipelined_num1[4].exp +1;
      pipelined_num1[4].mant     <= mant_sum[23:1];
    end else if(mant_sum[23]) begin // all good
      pipelined_num1[4].mant     <= mant_sum[22:0];
    end else begin // denormilize
      found_1                    <= 'b0;
      pipelined_num1[4].exp      <= 'b0;
      pipelined_num1[4].mant     <= 'b0;

      for(int i = 22; i >= 0; i--)begin
        if(mant_sum[i] && (!found_1)) begin
          pipelined_num1[4].exp  <= pipelined_num1[4].exp - (22 - i + 1);
          pipelined_num1[4].mant <= mant_sum[24:0] << (22 - i);
          found_1                <= 'b1;
        end
      end

      if(!found_1)
        pipelined_num1[4].sign   <= 'b0;


    end

  end

  assign result = pipelined_num1[5];

endmodule
