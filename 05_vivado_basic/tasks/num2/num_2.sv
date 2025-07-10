module num_2
# (
    parameter  w_sw          = 16,
               w_led         = 16
             
)
(
    input        [w_sw    - 1:0] sw_i,
    output logic [w_led   - 1:0] led_o
);

  typedef enum bit [15:0]
  {
    DATE_OF_BIRTH    = 16'd13_1_04,  
    PRIVET           = 16'b101,
    STRIPE           = 16'b10101010_10101010,
    INVERT_STRIPE    = 16'b0101010_101010101,
    LEFT             = 16'b1111_1111_0000_000,
    RIGHT            = 16'b1111_1111               
        
  }
  swith_to_code;
  
  always_comb begin
    led_o = 'b1111_1111_1111_1111;
    case(sw_i)
      16'd1   : led_o = DATE_OF_BIRTH;
      16'd2   : led_o = PRIVET;
      16'd4   : led_o = STRIPE;
      16'd8   : led_o = INVERT_STRIPE;
      16'd16  : led_o = LEFT;
      16'd32  : led_o = RIGHT; 
      
    endcase
  end

endmodule
