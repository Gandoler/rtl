module my_FDPE(
  input  logic data,
  input  logic clk,
  input  logic ce,
  input  logic rst,
  output logic out
);

  FDPE my_fdce (
    .Q(out),
    .C(clk),
    .CE(ce),
    .PRE(rst),
    .D(data)
  );


endmodule
