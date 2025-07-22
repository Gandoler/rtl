`include "struct_types.sv"
import float_struct::*;


module shift_reg_for_struct#(
  parameter STAGES = 6;
)(
  input                  clk,
  input                  rst,
  input  logic           en,
  input  float_point_num in_data,

  output float_point_num out_data
);


  float_point_num pipeline [0:STAGES-1];


  always_ff @(posedge clk) begin
    if(rst) begin
        for(int i=0; i < STAGES; i++)
          pipeline[i] <='b0;
    end
    else if(en) begin
      pipeline[0] <= in_data
      for(int i=1; i < STAGES; i++) begin
        pipeline[i] <= pipeline[i-1];
      end
    end


  end

  assign out_data <= pipeline[STAGES-1];

endmodule
