module my_FDSE(
  input  logic data,
  input  logic clk,
  input  logic ce,
  input  logic rst,
  output logic out
);

  FDSE my_fdce (
    .Q(out),
    .C(clk),
    .CE(ce),
    .S(rst),
    .D(data)
  );


endmodule
