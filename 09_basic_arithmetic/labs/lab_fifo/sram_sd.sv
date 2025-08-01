module sram_sd #(
  parameter WIDTH  = 8,
  parameter DEPTH  = 8,
  parameter ADDR_W = $clog2(DEPTH)
)(
  input  logic              clk_i,
  input  logic              wen_i,
  input  logic              ren_i,
  input  logic [ADDR_W-1:0] waddr_i,
  input  logic [ADDR_W-1:0] raddr_i,
  input  logic [WIDTH-1:0]  data_i,
  output loigc [WIDTH-1:0]  data_o
);

  logic [WIDTH-1:0] SRAM [DEPTH-1:0];


  always @(posedge clk_i) begin
    if(wen_i)
      SRAM[waddr_i] <= data_i;
  end



  always @(posedge clk_i) begin
    if(ren_i)
      data_o <= SRAM[raddr_i];
  end
