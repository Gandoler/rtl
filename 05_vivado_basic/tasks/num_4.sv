module num_4
# (
    parameter  w_7_indic     = 8
             
)
(
    input                             clk_i,
    input                             arstn_i,
    output logic  [w_7_indic   - 1:0] an_o,
    
    output logic                      ca_o, 
    output logic                      cb_o,
    output logic                      cc_o, 
    output logic                      cd_o, 
    output logic                      ce_o, 
    output logic                      cf_o, 
    output logic                      cg_o, 
    output logic                      dp_o
);

 typedef enum bit [7:0]
   {
       F     = ~8'b1000_1110,
       P     = ~8'b1100_1110,
       G     = ~8'b1011_1100,
       A     = ~8'b1110_1110,
       C     = ~8'b1001_1100,
       O     = ~8'b1111_1100,
       L     = ~8'b0001_1100
   } 
  words_encode;

  logic [31:0] cnt;
  
  logic [7:0]  an;
  logic [7:0]  abcdefg_dp_7segment;
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i)
      cnt <= 'b0;
    else 
      cnt <= cnt +1;
  end
  
  
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i)
      an <= 8'b11111110;
    else if (cnt[16:0] == 'b1)
      an <= {an[6:0],an[7]};
  end
  
  always_comb begin
    abcdefg_dp_7segment = 8'b1111_1111;
    case(an)
      8'b0111_1111:  abcdefg_dp_7segment = F;
      8'b1011_1111:  abcdefg_dp_7segment = P;
      8'b1101_1111:  abcdefg_dp_7segment = G;
      8'b1110_1111:  abcdefg_dp_7segment = A;
      8'b1111_0111:  abcdefg_dp_7segment = C;
      8'b1111_1011:  abcdefg_dp_7segment = O;
      8'b1111_1101:  abcdefg_dp_7segment = O;
      8'b1111_1110:  abcdefg_dp_7segment = L; 
    endcase
  end
  
  
  assign an_o = an;
  assign { ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o} = abcdefg_dp_7segment;

endmodule
