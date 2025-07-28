`include "C:/Users/glkru/intership/Internship/09_basic_arithmetic/source/fpu/struct_types.sv"
import struct_types::*;


module shift_reg_base#(
  parameter STAGES = 6, WIDTH=32
)(
  input                    clk,
  input                    rst,
  input  logic             en,
  input  logic [WIDTH-1:0] in_data,

  output logic [WIDTH-1:0] out_data
);


logic [WIDTH-1:0] pipeline [0:STAGES-1];


  always_ff @(posedge clk) begin
    if(rst) begin
        for(int i=0; i < STAGES; i++)
          pipeline[i] <='b0;
    end
    else if(en) begin
      pipeline[0] <= in_data;
      for(int i=1; i < STAGES; i++) begin
        pipeline[i] <= pipeline[i-1];
      end
    end
  end


  assign out_data = pipeline[STAGES-1];
endmodule
