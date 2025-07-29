module comb_logic (
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic [3:0] c,
  output logic [3:0] lut_o,
  output logic [3:0] minus_o,
  output logic [3:0] sum_o
);

  LUT3 #(.INIT(8'h1E) ) LUT3_0 (.O(lut_o[0]), .I0(a[0]), .I1(b[0]), .I2(c[0]));
  LUT3 #(.INIT(8'h1E) ) LUT3_1 (.O(lut_o[1]), .I0(a[1]), .I1(b[1]), .I2(c[1]));
  LUT3 #(.INIT(8'h1E) ) LUT3_2 (.O(lut_o[2]), .I0(a[2]), .I1(b[2]), .I2(c[2]));
  LUT3 #(.INIT(8'h1E) ) LUT3_3 (.O(lut_o[3]), .I0(a[3]), .I1(b[3]), .I2(c[3]));

  logic [3:0] S, DI, CO;

   assign S = a ^ b;
   assign DI = a & b;


  CARRY4 carry4_inst (
    .CI('b0),
    .DI(DI),
    .S(S),
    .CO(),
    .O(Sum)
  );

endmodule
