module fetch_stage(`include "struct_types.sv"
  input  logic           valid_i,
  input  float_point_num a_i,
  input  float_point_num b_i,

  output float_point_num a_o,
  output float_point_num b_o,
  output logic [1:0]     num_status

);


always_comb begin :

    if(arg_vld) begin
      a_o.sign  <= a_i.sign;
      a_o.exp   <= a_i.exp;
      a_o.mant  <= {1'b1, a_i.mant };

      b_o.sign  <= b_i.sign;
      b_o.exp   <= b_i.exp;
      b_o.mant  <= {1'b1, b_i.mant };
    end
end


endmodule
