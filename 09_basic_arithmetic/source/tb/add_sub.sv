module add_sub;

  logic [4:0] sum1, sum2, diff1, diff2;


always_comb begin
  sum1  = 5'd14 +  2'd2;
  sum2  = 5'd20 + 5'd15;
  diff1 = 5'd15 + ~(5'd5) + 1;
  diff2 = 5'd15 + ~(5'd18) + 1;
end



endmodule
