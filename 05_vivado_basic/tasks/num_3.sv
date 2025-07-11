module num_3
# (
    parameter  w_sw          = 16,
               w_led         = 16,
               w_7_indic     = 8
             
)
(
    input         [w_sw        - 1:0] sw_i,
    output logic  [w_led       - 1:0] led_o,
    output logic  [w_7_indic   - 1:0] an_o,
    
    output logic  ca_o, 
    output logic  cb_o,
    output logic  cc_o, 
    output logic  cd_o, 
    output logic  ce_o, 
    output logic  cf_o, 
    output logic  cg_o, 
    output logic  dp_o
);
 
typedef enum bit [7:0] {
    SEG_0 = 8'b1111110_1,
    SEG_1 = 8'b0110000_1,
    SEG_2 = 8'b1101101_1,
    SEG_3 = 8'b1111001_1,
    SEG_4 = 8'b0110011_1,
    SEG_5 = 8'b1011011_1,
    SEG_6 = 8'b1011111_1,
    SEG_7 = 8'b1110000_1,
    SEG_8 = 8'b1111111_1,
    SEG_9 = 8'b1111011_1,

    SEG_A = 8'b1110111_1,
    SEG_B = 8'b0011111_1, 
    SEG_C = 8'b1001110_1,
    SEG_D = 8'b0111101_1,  
    SEG_E = 8'b1001111_1,
    SEG_F = 8'b1000111_1,
    SEG_G = 8'b1011110_1,
    SEG_H = 8'b0110111_1,  
    SEG_I = 8'b0000110_1, 
    SEG_J = 8'b0111000_1,
    SEG_K = 8'b1010111_1, 
    SEG_L = 8'b0001110_1,
    SEG_M = 8'b1110110_1,
    SEG_N = 8'b0010101_1, 
     
    SEG_P = 8'b1100111_1,
    SEG_Q = 8'b1110011_1,  
    SEG_R = 8'b0000101_1,  
   
    SEG_T = 8'b0001111_1,  
    SEG_U = 8'b0111110_1,  
    SEG_V = 8'b0011100_1,  
    

    SEG_Y = 8'b0111011_1,  

    SEG_SPACE        = 8'b0000000_1, 
    SEG_MINUS        = 8'b0000001_1, 
    SEG_UNDERSCORE   = 8'b0001000_1, 
    SEG_EQUALS       = 8'b0001001_1, 
    SEG_DEGREE       = 8'b1100011_1, 
    SEG_POINT        = 8'b0000000_0  
} seven_seg_encoding_e;
 
 
 
  logic [7:0] abcdefg_dp_7segment;
  assign { ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o} = abcdefg_dp_7segment;
  
  always_comb begin 
    abcdefg_dp_7segment = 'b0000_000_0;
    
    case(sw_i[12:0])
        13'd0 : abcdefg_dp_7segment = SEG_0;
        13'd1 : abcdefg_dp_7segment = SEG_1;
        13'd2 : abcdefg_dp_7segment = SEG_2;
        13'd3 : abcdefg_dp_7segment = SEG_3;
        13'd4 : abcdefg_dp_7segment = SEG_4;
        13'd5 : abcdefg_dp_7segment = SEG_5;
        13'd6 : abcdefg_dp_7segment = SEG_6;
        13'd7 : abcdefg_dp_7segment = SEG_7;
        13'd8 : abcdefg_dp_7segment = SEG_8;
        13'd9 : abcdefg_dp_7segment = SEG_9;
         
        13'd10 :  abcdefg_dp_7segment = SEG_A;  
        13'd11 :  abcdefg_dp_7segment = SEG_B;
        13'd12 :  abcdefg_dp_7segment = SEG_C;  
        13'd13 :  abcdefg_dp_7segment = SEG_D;  
        13'd14 :  abcdefg_dp_7segment = SEG_E;  
        13'd15 :  abcdefg_dp_7segment = SEG_F;  
        13'd16 :  abcdefg_dp_7segment = SEG_G;
        13'd17 :  abcdefg_dp_7segment = SEG_H; 
        13'd16 :  abcdefg_dp_7segment = SEG_I; 
        13'd19 :  abcdefg_dp_7segment = SEG_J; 
        13'd21 :  abcdefg_dp_7segment = SEG_K; 
        13'd22 :  abcdefg_dp_7segment = SEG_L; 
        13'd23 :  abcdefg_dp_7segment = SEG_M; 
        13'd24 :  abcdefg_dp_7segment = SEG_N; 
        13'd25 :  abcdefg_dp_7segment = SEG_0;
        13'd26 :  abcdefg_dp_7segment = SEG_P; 
        13'd27 :  abcdefg_dp_7segment = SEG_Q; 
        13'd28 :  abcdefg_dp_7segment = SEG_R; 
        13'd29 :  abcdefg_dp_7segment = SEG_5; 
        13'd30 :  abcdefg_dp_7segment = SEG_T; 
        13'd31 :  abcdefg_dp_7segment = SEG_U; 
        13'd32 :  abcdefg_dp_7segment = SEG_V; 
        13'd33 :  abcdefg_dp_7segment = SEG_U; 
        13'd34 :  abcdefg_dp_7segment = SEG_H; 
        13'd35 :  abcdefg_dp_7segment = SEG_Y; 
        13'd36 :  abcdefg_dp_7segment = SEG_2;     
         
        13'd37 :  abcdefg_dp_7segment = SEG_SPACE;  
        13'd38 :  abcdefg_dp_7segment = SEG_MINUS;
        13'd39 :  abcdefg_dp_7segment = SEG_UNDERSCORE;  
        13'd40 :  abcdefg_dp_7segment = SEG_DEGREE;  
        13'd41 :  abcdefg_dp_7segment = SEG_POINT;    
    endcase
  end
  
  
   always_comb begin 
     an_o = 'b0;
     case (sw_i[15:13])
       3'b1     :  an_o = 8'b1111_1110;
       3'b10    :  an_o = 8'b1111_1101;
       3'b11    :  an_o = 8'b1111_1011;
       3'b100   :  an_o = 8'b1111_0111;
       3'b101   :  an_o = 8'b1110_1111;
       3'b110   :  an_o = 8'b1101_1111;
       3'b111   :  an_o = 8'b1011_1111;
     
     endcase
   end
endmodule
