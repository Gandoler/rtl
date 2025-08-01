module fifo_dualport #(
  parameter WIDTH  = 8,
  parameter DEPTH  = 8,
)(
  input  logic              clk_i,
  input  logic              valid_i,
  input  logic              ready_i,
  input  logic [WIDTH-1:0]  data_i,

  output logic [WIDTH-1:0]  data_o,
  output logic              ready_o,
  output logic              valid_o
);

  localparam pointer_width = $clog2 (DEPTH);
  localparam max_ptr       = pointer_width' (DEPTH - 1);




endmodule
