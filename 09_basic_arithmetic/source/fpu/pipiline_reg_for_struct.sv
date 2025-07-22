`include "struct_types.sv"
import float_struct::*;


module shift_reg_for_struct#(
  parameter STAGES = 6;
)(
  input                  clk,
  input                  rst,
  input  logic           en,
  input  float_point_num in_data,

  output float_point_num out_data [0 : STAGES-1]
);




  always_ff @(posedge clk) begin
    if(rst) begin
        for(int i=0; i < STAGES; i++)
          out_data[i] <='b0;
    end
    else if(en) begin
      out_data[0] <= in_data
      for(int i=1; i < STAGES; i++) begin
        out_data[i] <= out_data[i-1];
      end
    end


  end
endmodule
