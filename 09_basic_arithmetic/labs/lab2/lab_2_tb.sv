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

  initial begin

    a = 4'b0000; b = 4'b0000; c = 4'b0000; #10; check_outputs();
    a = 4'b1010; b = 4'b0101; c = 4'b1111; #10; check_outputs();
    a = 4'b1111; b = 4'b1111; c = 4'b0000; #10; check_outputs();
    a = 4'b1001; b = 4'b0110; c = 4'b0011; #10; check_outputs();
    a = 4'b0011; b = 4'b0001; c = 4'b1010; #10; check_outputs();
    a = 4'b1100; b = 4'b0011; c = 4'b0101; #10; check_outputs();
    a = 4'b0001; b = 4'b0001; c = 4'b0001; #10; check_outputs();

    $display("All test cases completed.");
    $stop;
  end

endmodule
