module pipilined_answer_tb#(
  parameter DATA_WIDTH = 8
)();
  logic                      clk_i;
  logic                      rst_i;
  logic [DATA_WIDTH-1:0]     pow_data_i;
  logic                      data_valid_i;
  logic [(5*DATA_WIDTH)-1:0] pow_data_o;
  logic                      data_valid_o;


  pow5_pipelined_answer #(
    .DATA_WIDTH(DATA_WIDTH)
  ) DUT (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .pow_data_i   (pow_data_i),
    .data_valid_i (data_valid_i),
    .pow_data_o   (pow_data_o),
    .data_valid_o (data_valid_o)
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
    data_valid_i = 0;
    pow_data_i = 0;
    #(3*CLK_PERIOD);
    rst_i <= 0;
  end

  // Генерация входных воздействий
  initial begin
    wait(!rst_i);
    repeat(100) begin
      @(posedge clk_i);
      pow_data_i   <= $urandom_range(0, 2**DATA_WIDTH-1);//2**DATA_WIDTH-1
      data_valid_i <=1;
    end
    repeat(10) begin
      @(posedge clk_i);
      data_valid_i <=0;
      @(posedge clk_i);
      pow_data_i   <= $urandom_range(0, 2**DATA_WIDTH-1);//2**DATA_WIDTH-1
      data_valid_i <=1;
    end

  end

  typedef struct {
    logic [DATA_WIDTH-1:0]     input_data;
    logic [(5*DATA_WIDTH)-1:0] expected;
  } pkt;


  mailbox#(pkt) exp_mbx  = new();



   // сохранение в мэил бокс
  initial begin
    pkt pkt;
    wait(!rst_i);
    forever begin
      @(posedge clk_i);
      pkt.input_data    = pow_data_i;
      pkt.expected = (pow_data_i ** 5);
      if(data_valid_i)
        exp_mbx.put(pkt);
    end
  end


  // проверка
   initial begin
    pkt pkt;
    wait(!rst_i);
    forever begin
      @(posedge clk_i);
      if(data_valid_o) begin
        exp_mbx.get(pkt);
          if (pow_data_o !== pkt.expected) begin
            $error("[%0t] ERROR: input_data=%0d, expected=%0d, got=%0d",
              $time, pkt.input_data, pkt.expected, pow_data_o);
          end else begin
            $display("[%0t] OK: input_data=%0d, pow5=%0d",
              $time, pkt.input_data, pow_data_o);
          end
      end
    end
  end

  // Таймаут
  initial begin
   repeat(100000) @(posedge clk_i);
   $stop();
  end

endmodule
