module my_FDCE(
  input  logic data,
  input  logic clk,
  input  logic ce,
  input  logic rst,
  output logic out
);

  FDCE my_fdce (
    .Q(out),
    .C(clk),
    .CE(ce),
    .CLR(rst),
    .D(data)
  );


endmodule
