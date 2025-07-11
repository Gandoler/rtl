module num_5
# (
    parameter  w_7_indic     = 8,
               w_led         = 16      
)
(
    input                             clk_i,
    input                             arstn_i,
    
    input                             BTNL,
    input                             BTNR,
    
    output logic  [w_7_indic   - 1:0] an_o,
    output logic  [w_led   - 1:0]     led_o,
    
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
       UP      = ~8'b1100_0100,
       DOWN    = ~8'b0011_1000,
       HEAD    = ~8'b1111_1100,
       LINE    = ~8'b0000_0010,
       TAIL    = ~8'b0000_0110,
       SPACE   = ~8'b0000_0000    
   } 
  words_encode;
  
  
 logic btnR_last_state;
 logic btnL_last_state;

  logic [31:0] cnt;
  logic [3:0]  snake_cnt;
  logic [22:0] speed;
  
  logic [7:0]  an;
  logic [7:0]  abcdefg_dp_7segment;
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i) begin
      cnt   <= 'b0;
    end
    else 
      cnt   <= cnt +1;
  end
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i) begin
      btnR_last_state <=0;
      btnL_last_state <=0;
    end
    else begin
      btnR_last_state <= BTNR? 1:0;
      btnL_last_state <= BTNL? 1:0;
    end
  end
  
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i)  
      speed          <= {20{1'b1}};
    else if(~BTNR && btnR_last_state) 
      if(speed < {16{1'b1}}) speed        <= {20{1'b1}};
      else                   speed        <= (speed >> 1);
    else if(~BTNL && btnL_last_state)
      if(speed >= {22{1'b1}})  speed        <= (speed << 1);
  end
  
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i) begin
      an                <= 8'b11111110;
      snake_cnt         <=0;
    end
    else if (cnt == speed) begin
      an                <= {an[6:0],an[7]};
      snake_cnt         <= snake_cnt+1;
    end
  end
  
  always_comb begin
    abcdefg_dp_7segment = ~8'b0000_0000     ;
    case(snake_cnt)
      4'd0: abcdefg_dp_7segment = SPACE;
      4'd1: abcdefg_dp_7segment = SPACE;
      4'd2: abcdefg_dp_7segment = HEAD;
      4'd3: abcdefg_dp_7segment = DOWN;
      4'd4: abcdefg_dp_7segment = LINE;
      4'd5: abcdefg_dp_7segment = UP;
      4'd6: abcdefg_dp_7segment = LINE;
      4'd7: abcdefg_dp_7segment = TAIL;
      4'd8: abcdefg_dp_7segment = SPACE;
    endcase
  end
  
  
  assign an_o = an;
  assign { ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o} = abcdefg_dp_7segment;
  assign led_o = {~speed[21:16],{(w_led-5){1'b0}}};
endmodule
