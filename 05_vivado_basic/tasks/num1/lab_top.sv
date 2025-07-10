
module lab_top
# (
    parameter  w_sw          = 16,
               w_led         = 16
             
)
(
    input        [w_sw    - 1:0] sw_i,
    output logic [w_led   - 1:0] led_o
);

    
   
   assign led_o = sw_i;

endmodule
