module my_FDRE(
  input  logic data,
  input  logic clk,
  input  logic ce,
  input  logic rst,
  output logic out
);

  FDRE my_fdce (
    .Q(out),
    .C(clk),
    .CE(ce),
    .R(rst),
    .D(data)
  );


endmodule
