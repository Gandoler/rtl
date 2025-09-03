module syst_ws_tb();

logic clk_i;
logic rst_i;
logic [7:0] x1_i;
logic [7:0] x2_i;
logic [7:0] x3_i;
logic [18:0] y1_o;
logic [18:0] y2_o;

localparam W11 = 8'd2;
localparam W12 = 8'd3;
localparam W13 = 8'd4;
localparam W21 = 8'd5;
localparam W22 = 8'd6;
localparam W23 = 8'd7;

syst_ws syst_ws1
(
  .clk_i(clk_i),
  .rst_i(rst_i),

  .x1_i (x1_i),
  .x2_i (x2_i),
  .x3_i (x3_i),

  . y1_o(y1_o),
  . y2_o(y2_o)
);


parameter CLK_PERIOD = 10;
  // Генерация тактового сигнала
  initial begin
    clk_i <= 0;
    forever begin
        #(CLK_PERIOD/2) clk_i = ~clk_i;// Пишите тут.
    end
  end

  // Генерация сигнала сброса
  initial begin
    rst_i <= 1;
    x1_i  <= 0;
    x2_i  <= 0;
    x3_i  <= 0;
    #(4*CLK_PERIOD);
    rst_i <= 0;
  end


   // Генерация входных воздействий
  initial begin
    wait(!rst_i);
    @(posedge clk_i);

    repeat(100) begin
      @(posedge clk_i);
      x1_i   <= $urandom_range(0,2);// 2**8-1
      x2_i   <= $urandom_range(0, 4);
      x3_i   <= $urandom_range(0, 3);
    end
  end

  typedef struct {
    logic [7:0]  x1_input;
    logic [7:0]  x2_input;
    logic [7:0]  x3_input;
    logic [18:0] y1_expected;
    logic [18:0] y2_expected;
  } pkt;


  mailbox#(pkt) exp_mbx  = new();


   // сохранение в мэил бокс
  initial begin
    pkt pkt;
    wait(!rst_i);
    forever begin
      @(posedge clk_i);
      pkt.x1_input    = x1_i;
      pkt.x2_input    = x2_i;
      pkt.x3_input    = x3_i;
      pkt.y1_expected = x1_i*W11 + x2_i*W12 + x3_i*W13;
      pkt.y2_expected = x1_i*W21 + x2_i*W22 + x3_i*W23;
      exp_mbx.put(pkt);
    end
  end

   // проверка
   initial begin
    pkt pkt;
    wait(!rst_i);
    @(posedge clk_i);

    forever begin
      @(posedge clk_i);
        exp_mbx.get(pkt);
        @(posedge clk_i);
        if (y1_o !== pkt.y1_expected)
          $error("[%0t] ERROR: input_data: x1=%0d,x2=%0d,x3=%0d expected: y1=%0d, got: y1=%0d",
            $time, pkt.x1_input, pkt.x2_input, pkt.x3_input, pkt.y1_expected, y1_o);
        else
          $display("[%0t] OK:  input_data: x1=%0d,x2=%0d,x3=%0d, res: y1=%0d",
            $time,  pkt.x1_input, pkt.x2_input, pkt.x3_input, y1_o);

        @(posedge clk_i);

        if (y2_o !== pkt.y2_expected)
         $error("[%0t] ERROR: input_data: x1=%0d,x2=%0d,x3=%0d expected: y2=%0d, got: y2=%0d",
           $time, pkt.x1_input, pkt.x2_input, pkt.x3_input, pkt.y2_expected, y2_o);
        else
          $display("[%0t] OK:  input_data: x1=%0d,x2=%0d,x3=%0d, res: y2=%0d",
            $time,  pkt.x1_input, pkt.x2_input, pkt.x3_input, y2_o);

      end
  end

  // Таймаут
  initial begin
   repeat(100000) @(posedge clk_i);
   $stop();
  end

endmodule
