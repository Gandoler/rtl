module lab_2_tb ();
  logic [3:0] a,
  logic [3:0] b,
  logic [3:0] c,
  logic [3:0] lut_o,
  logic [3:0] minus_o,
  logic [3:0] sum_o

  comb_logic (
  .a(a),
  .b(b),
  .c(c),
  .lut_o(lut_o),
  .minus_o(minus_o),
  .sum_o(sum_o)
);


endmodule
