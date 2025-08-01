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


  logic             ren;
  logic             wen;
  logic [WIDTH-1:0] sram_out;



  logic             en_bypass
  logic [WIDTH-1:0] data_bypass;

  sram_sd #(
  .WIDTH (8),
  .DEPTH (8),
  .ADDR_W($clog2(DEPTH))
  )(
  .clk_i(),
  .wen_i(),
  .ren_i(),
  .waddr_i(),
  .raddr_i(),
  .data_i(data_i),

  .data_o(sram_out)
  )

endmodule
