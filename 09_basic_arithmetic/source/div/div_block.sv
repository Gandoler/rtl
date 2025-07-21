module div_block(
  input  logic R,
  input  logic B,
  input  logic C_in,
  input  logic N,

  output logic C_out,
  output logic D,
  output logic B_out,
  output logic R_out
);

logic adder_sum;

fulladder adder(
  a_i(R),
  b_i(B),
  carry_i(C_in),
  sum_o(adder_sum),

  carry_o(C_out)
);


always_comb begin
  D     = adder_sum;
  N     = adder_sum;
  B_out = B;
  R_out = N? R : adder_sum;
end


endmodule
