module fpu_adder_tb ();
  float_point_num num1, num2, res;
  reg clk;
  reg rst;
  logic [1:0] res_state



floating_point_adder #(.STAGES(6), .WIDTH(2)) adder_dut
  (
    .clk(clk),
    .rst(rst),

    .a(num1),
    .b(num2),
    .arg_vld(arg_vld),

    .result(res),
    .res_state(res_state)
);





endmodule
