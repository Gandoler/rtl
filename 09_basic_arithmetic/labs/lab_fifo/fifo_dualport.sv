module fifo_dualport #(
  parameter WIDTH  = 8,
  parameter DEPTH  = 8
)(
  input  logic              clk_i,
  input  logic              rst_i,
  input  logic              valid_i,
  input  logic              ready_i,
  input  logic [WIDTH-1:0]  data_i,

  output logic [WIDTH-1:0]  data_o,
  output logic              ready_o,
  output logic              valid_o
);

  localparam pointer_width = $clog2 (DEPTH);
  localparam max_ptr       = pointer_width' (DEPTH - 1);

  logic  push;
  logic  pop;
  assign push = valid_i;
  assign pop  = ready_i;

  logic                     ren;
  logic                     wen;
  logic [WIDTH-1:0]         sram_out;

  logic [pointer_width-1:0] wr_ptr;
  logic [pointer_width-1:0] rd_ptr;
  logic                     wr_circle_odd;
  logic                     rd_circle_odd;



  sram_sd #(
  .WIDTH (WIDTH),
  .DEPTH (DEPTH),
  .ADDR_W(pointer_width)
  ) sram_sd1(
  .clk_i(clk_i),
  .wen_i(wen),
  .ren_i(ren),
  .waddr_i(wr_ptr),
  .raddr_i(rd_ptr),
  .data_i(data_i),
  .data_o(sram_out)
  );

  always_ff @ (posedge clk_i) begin : for_wr_ptr
    if (rst_i) begin
      wr_ptr <= 'b0;
      wr_circle_odd <= 1'b0;
    end
    else if (push) begin
      if (wr_ptr == max_ptr)
      begin
        wr_ptr <= '0;
        wr_circle_odd <= ~ wr_circle_odd;
      end
      else begin
        wr_ptr <= wr_ptr + 1'b1;
      end
    end
  end

  always_ff @ (posedge clk_i) begin : for_read_ptr
    if (rst_i) begin
      rd_ptr <= '0;
      rd_circle_odd <= 1'b0;
    end
    else if (push) begin
      if (rd_ptr == max_ptr)
      begin
        rd_ptr <= '0;
        rd_circle_odd <= ~ rd_circle_odd;
      end
      else begin
        rd_ptr <= rd_ptr + 1'b1;
      end
    end
  end




  logic equal_ptrs;
  logic same_circle;
  logic empty;
  logic full;

  always_comb begin
    equal_ptrs  = wr_ptr == rd_ptr;
    same_circle = wr_circle_odd == rd_circle_odd;
    empty       = equal_ptrs && same_circle;
    full        = equal_ptrs && ~same_circle;
    wen         = push && !full;
    ren         = pop  && !empty;
  end

  assign data_o = sram_out;
  assign ready_o = full? (1'b0):(1'b1);
  assign valid_o = empty? (1'b0):(1'b1);

endmodule
