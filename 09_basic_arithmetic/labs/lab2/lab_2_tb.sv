`timescale 1ns / 1ps

module lab_2_tb;

  logic [3:0] a, b, c;
  logic [3:0] lut_o;
  logic [3:0] minus_o;
  logic [3:0] sum_o;

  logic [3:0] expected_lut, expected_minus, expected_sum;

  comb_logic dut (
    .a(a),
    .b(b),
    .c(c),
    .lut_o(lut_o),
    .minus_o(minus_o),
    .sum_o(sum_o)
  );

  logic clk = 0;
  logic rst = 0;
  logic ce = 0;
  logic data = 0;
  my_FDCE u_fdce (.data(data), .clk(clk), .ce(ce), .rst(rst), .out(out_fdce));
  my_FDPE u_fdpe (.data(data), .clk(clk), .ce(ce), .rst(rst), .out(out_fdpe));
  my_FDRE u_fdre (.data(data), .clk(clk), .ce(ce), .rst(rst), .out(out_fdre));
  my_FDSE u_fdse (.data(data), .clk(clk), .ce(ce), .rst(rst), .out(out_fdse));
  logic out_fdce, out_fdpe, out_fdre, out_fdse;
  logic exp_fdce, exp_fdpe, exp_fdre, exp_fdse;


  task check_outputs;
    begin
      expected_lut   = (a ^ (b | c));
      expected_minus = a - b;
      expected_sum   = a + b;

      $display("a=%b b=%b c=%b | lut_o=%b sum_o=%b minus_o=%b", a, b, c, lut_o, sum_o, minus_o);

      if (lut_o !== expected_lut)
        $error("LUT mismatch: expected %b, got %b", expected_lut, lut_o);

      if (minus_o !== expected_minus)
        $error("MINUS mismatch: expected %b, got %b", expected_minus, minus_o);

      if (sum_o !== expected_sum)
        $error("SUM mismatch: expected %b, got %b", expected_sum, sum_o);
    end
  endtask


    task check_outputs_trig;
    input string msg;
    begin
      if (out_fdce !== exp_fdce) $error("FDCE FAIL @ %0t: %s (got %b, expected %b)", $time, msg, out_fdce, exp_fdce);
      if (out_fdpe !== exp_fdpe) $error("FDPE FAIL @ %0t: %s (got %b, expected %b)", $time, msg, out_fdpe, exp_fdpe);
      if (out_fdre !== exp_fdre) $error("FDRE FAIL @ %0t: %s (got %b, expected %b)", $time, msg, out_fdre, exp_fdre);
      if (out_fdse !== exp_fdse) $error("FDSE FAIL @ %0t: %s (got %b, expected %b)", $time, msg, out_fdse, exp_fdse);
    end
  endtask

always #5 clk = ~clk;
  initial begin

    a = 4'b0000; b = 4'b0000; c = 4'b0000; #10; check_outputs();
    a = 4'b1010; b = 4'b0101; c = 4'b1111; #10; check_outputs();
    a = 4'b1111; b = 4'b1111; c = 4'b0000; #10; check_outputs();
    a = 4'b1001; b = 4'b0110; c = 4'b0011; #10; check_outputs();
    a = 4'b0011; b = 4'b0001; c = 4'b1010; #10; check_outputs();
    a = 4'b1100; b = 4'b0011; c = 4'b0101; #10; check_outputs();
    a = 4'b0001; b = 4'b0001; c = 4'b0001; #10; check_outputs();

    $display("All test LUT AND CARRY4 cases completed.");


    #50;


    ce = 1;
    data = 1;
    rst = 1;


    #2;
    exp_fdce = 0;
    exp_fdpe = 1;

    check_outputs_trig("async reset check");

    #8;
    exp_fdre = 0;
    exp_fdse = 1;
    check_outputs_trig("sync reset check");

    rst = 0;

    data = 1;
    @(posedge clk);
    exp_fdce = 1;
    exp_fdpe = 1;
    exp_fdre = 1;
    exp_fdse = 1;
    check_outputs_trig("data=1 load");

    data = 0;
    @(posedge clk);
    exp_fdce = 0;
    exp_fdpe = 0;
    exp_fdre = 0;
    exp_fdse = 0;
    check_outputs_trig("data=0 load");

    ce = 0;
    data = 1;
    data = 1;
    @(posedge clk);
    check_outputs_trig("CE=0 hold check");

    $display("Test completed.");
    $finish;

    $stop;
  end

endmodule
