module shift_reg
# (parameter WIDTH, STAGES)
(
 input  loigc              clk,
 input  logic              rst,
 input  logic [WIDTH - 1:0] enter,


 output logic [WIDTH - 1:0] leave

);

  logic [WIDTH - 1:0] shift_reg [0 : STAGES];

  always_ff @(posedge clk) begin
    if(rst) begin
      for (int i = 0; i < STAGES; i ++)
        shift_reg [i] <= 'b0;
    end else
      shift_reg [0]   <= enter;
      for (int i = 1; i < STAGES; i ++)
        shift_reg [i] <= shift_reg [i-1] ;
  end


  assign leave = shift_reg[STAGES-1];


endmodule
