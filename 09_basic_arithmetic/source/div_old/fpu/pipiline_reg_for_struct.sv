`include "C:\Users\glkru\intership\Internship\09_basic_arithmetic\source\fpu\struct_types.sv"
import struct_types::*;

module pipiline_reg_for_struct #(
  parameter STAGES = 6
)(
  input                  clk,
  input                  rst,
  input  logic           en,
  input  float_point_num in_data,
  output float_point_num out_data [0:STAGES-1]
);

float_point_num reg_data [0:STAGES-1];

always_ff @(posedge clk) begin
  if (rst) begin
    foreach (reg_data[i])
      reg_data[i] <= '{sign:1'b0, exp:8'b0, mant:23'b0};
  end
  else if (en) begin
    reg_data[0]   <= in_data;

    for (int i = 1; i < STAGES; i++)
      reg_data[i] <= reg_data[i-1];
  end
end

// ���������� ��������� �������
assign out_data = reg_data;

endmodule
