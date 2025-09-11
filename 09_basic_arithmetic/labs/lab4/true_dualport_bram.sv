module true_dualport_bram
#(
  parameter NB_COL = 4,
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10
)
(
  input  logic                     clk_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_a_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_b_i,
  input  logic [RAM_WIDTH-1:0]     data_a_i,
  input  logic [RAM_WIDTH-1:0]     data_b_i,
  input  logic [NB_COL-1:0]        we_a_i,
  input  logic [NB_COL-1:0]        we_b_i,
  input  logic                     en_a_i,
  input  logic                     reg_en_a_i,
  input  logic                     en_b_i,
  output logic [RAM_WIDTH-1:0]     data_a_o,
  output logic [RAM_WIDTH-1:0]     data_b_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [RAM_WIDTH-1:0] bram [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] ram_data_a_ff;
  logic [RAM_WIDTH-1:0] ram_data_b_ff;

  always_ff @(posedge clk_i) begin
    if (en_a_i) begin
        ram_data_a_ff <= bram[addr_a_i];
    end
  end


  always_ff @(posedge clk_i) begin
    if (rst_i)
      data_a_out_reg_ff <= {RAM_WIDTH{1'b0}};
    else if (reg_en_i)
      data_a_out_reg_ff <= ram_data_a_ff;
  end


  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always_ff @(posedge clk_i)
         if (en_a_i)
           if (we_a_i[i])
             bram[addr_a_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_a_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate


  always_ff @(posedge clk_i) begin
    if (en_b_i) begin
        ram_data_b_ff <= bram[addr_b_i];
    end
  end


  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always_ff @(posedge clk_i)
         if (en_b_i)
           if (we_b_i[i])
             bram[addr_b_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_b_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate


  assign data_a_o = data_a_out_reg_ff;
  assign data_b_o = ram_data_b_ff;

endmodule
