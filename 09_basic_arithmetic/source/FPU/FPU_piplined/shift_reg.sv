module shift_reg
# (parameter WIDTH=2, STAGES=2)
(
 input  logic               clk_i,
 input  logic               rst_i,
 input  logic [WIDTH - 1:0] enter,
 input  logic               en,


 output logic [WIDTH - 1:0] leave

);

  logic [WIDTH - 1:0] shift_reg [0 : STAGES];

  always_ff @(posedge clk_i) begin
    if(rst_i) begin
      for (int i = 0; i < STAGES; i ++)
        shift_reg [i] <= 'b0;
    end else if(en)
      shift_reg [0]   <= enter;
      for (int i = 1; i < STAGES; i ++)
        shift_reg [i] <= shift_reg [i-1] ;
  end


  assign leave = shift_reg[STAGES-1];


endmodule
