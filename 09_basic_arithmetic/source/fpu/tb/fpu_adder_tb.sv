`timescale 1ns/1ps

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

   initial clk = 0;
    always #10 clk = ~clk;
    initial begin
      $display( "\nTest has been started.");
      rst = 1;
      #40;
      rst = 0;
      #10
      num1 = '{sign:1'b0, exp:8'b01111111, mant:23'b00100110011001100110011} // 1.12
      num2 = '{sign:1'b0, exp:8'b10000001, mant:23'b00101001100110011001101} // 4.65
      #8000;


      $display("\n The test is over \n See the internal signals of the module on the waveform \n");
      $finish;
      #5;
        $display("You're trying to run simulation that has finished. Aborting simulation.");
      $fatal();
    end








endmodule
