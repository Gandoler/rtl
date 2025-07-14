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

 logic [7:0] symbols [7:0];  
 
 typedef enum bit [7:0]
   {
       UP      = ~8'b1100_0100,
       DOWN    = ~8'b0011_1000,
       HEAD    = ~8'b1111_1100,
       LINE    = ~8'b0000_0010,
       TAIL    = ~8'b0100_0010,
       SPACE   = ~8'b0000_0000    
   } 
  words_encode;
  
  
 logic       btnR_last_state, btnL_last_state;
 logic       request_left, request_right;
 logic       speed_up_enable ,speed_down_enable;

  logic [31:0] cnt;
  logic [2:0] speed;
  
  logic [7:0]  an;
  logic [7:0]  abcdefg_dp_7segment;
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin //  синхронный счетчик
    if(~arstn_i) begin
      cnt   <= 'b0;
    end
    else 
      cnt   <= cnt + speed;
  end
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin  // инициализация и движения массива змейки
   if(~arstn_i) begin
      symbols[0] <= SPACE;
      symbols[1] <= TAIL;
      symbols[2] <= LINE;
      symbols[3] <= UP;
      symbols[4] <= DOWN;
      symbols[5] <= LINE;
      symbols[6] <= HEAD;
      symbols[7] <= SPACE;
    end
    else if((cnt[22:0]) == 'b1)begin
       for (int i = 0; i < 7; i++) begin
            symbols[i+1] <= symbols[i];
        end
        symbols[0] <= symbols[7];
    end
  end
  
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin // сохранение результатов последних нажатий
    if(~arstn_i) begin
      btnR_last_state   <=0;
      btnL_last_state   <=0;
     
    end
    else begin
      btnR_last_state   <=BTNR;
      btnL_last_state   <=BTNL;
    end
  end
  
  

  
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin  // работа со скростью 
    if(~arstn_i)  
      speed     <= 1;
    else begin
      if(BTNR  && (~btnR_last_state) && ~speed[2]) 
        speed   <= (speed << 1);   
      if(BTNL  && (~btnL_last_state) && ~speed[0])  
        speed   <= (speed >> 1);
    end
  end
  
  
  always_ff @((posedge clk_i) or (negedge arstn_i)) begin
    if(~arstn_i)
      an <= 8'b11111110;
    else if ((&cnt[17:0]) == 'b1)
      an <= {an[6:0],an[7]};
  end
  
  always_comb begin
    abcdefg_dp_7segment = 8'b1111_1111;
    case(an)
      8'b11111110: abcdefg_dp_7segment = symbols[0];
      8'b11111101: abcdefg_dp_7segment = symbols[1];
      8'b11111011: abcdefg_dp_7segment = symbols[2];
      8'b11110111: abcdefg_dp_7segment = symbols[3];
      8'b11101111: abcdefg_dp_7segment = symbols[4];
      8'b11011111: abcdefg_dp_7segment = symbols[5];
      8'b10111111: abcdefg_dp_7segment = symbols[6];
      8'b01111111: abcdefg_dp_7segment = symbols[7];
      endcase 
  end
  
  
  assign an_o = an;
  assign { ca_o, cb_o, cc_o, cd_o, ce_o, cf_o, cg_o, dp_o} = abcdefg_dp_7segment;
  assign led_o = {speed,{(w_led-3){1'b0}}};
endmodule
