module syst_ws_tb#(
  parameter WIDTH_X = 7,
  parameter WIDTH_Y = 18
)();

//---------------------------------
// Сигналы
//---------------------------------
  logic clk;
  logic rst;

  logic [WIDTH_X:0] x1_i, x2_i, x3_i;
  logic [WIDTH_Y:0] y1_o, y2_o;


//---------------------------------
// тестируемое устройство
//---------------------------------
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


//---------------------------------
// Переменные тестирования
//---------------------------------

// Период тактового сигнала
  parameter CLK_PERIOD = 10;

// Пакет и mailbox'ы
  typedef struct {
      rand logic [WIDTH_X:0]  x1_i;
      rand logic [WIDTH_X:0]  x2_i;
      rand logic [WIDTH_X:0]  x3_i;
  } packet_in;
  typedef struct {
      rand logic [WIDTH_Y:0] y1_o;
      rand logic [WIDTH_Y:0] y2_o;
  } packet_out;

  mailbox#(packet_in) gen2drv = new();
  mailbox#(packet_in) in_mbx  = new();
  mailbox#(packet_out) out_mbx = new();


//---------------------------------
// Методы
//---------------------------------
// Генерация тактового сигнала


// Генерация сигнала сброса
  task reset();
      rst_i <= 1;
      #(10 * CLK_PERIOD);
      rst_i <= 0;
  endtask

//аймаут теста
  task timeout(int timeout_cycles = 100000);
      repeat(timeout_cycles) @(posedge clk_i);
      $stop();
  endtask

// Master
  task gen_master(
      int size_min   = 1,
      int size_max   = 10,
  );
    packet p;
    p.x1_i = $urandom_range(0, 2**WIDTH_X-1);
    p.x2_i = $urandom_range(0, 2**WIDTH_X-1);
    p.x3_i = $urandom_range(0, 2**WIDTH_X-1);
    gen2drv.put(p);

  endtask


  task do_master_gen(
        int pkt_amount = 100,
    );
        repeat(pkt_amount) begin
            gen_master(size_min, size_max);
        end
  endtask


  task reset_master();
        wait(rst_i);
        x1_i  <= 0;
        x2_i  <= 0;
        x3_i  <= 0;
        wait(~rst_i);
  endtask



  task drive_master(packet p);
        x1_i  <= p.x1_i;
        x2_i  <= p.x2_i;
        x3_i  <= p.x3_i;
        @(posedge clk);
  endtask


  task do_master_drive();
        packet p;
        reset_master();
        @(posedge clk);
        forever begin
            gen2drv.get(p);
            drive_master(p);
        end
  endtask


  task monitor_master();
        packet p;
        @(posedge clk);
            p.x1_i  = x1_i;
            p.x2_i  = x2_i;
            p.x3_i  = x3_i;
            in_mbx.put(p);
  endtask


  task do_master_monitor();
        wait(~rst_i);
        forever begin
            monitor_master();
        end
  endtask

  // Master
  task master(
      int gen_pkt_amount = 100
  );
      fork
          do_master_gen(gen_pkt_amount);
          do_master_drive();
          do_master_monitor();
      join
  endtask


  // Slave
  task monitor_slave();
        packet p;
        @(posedge clk);
          p.y1_o  = y1_o;
          p.y2_o  = y1_o;
          out_mbx.put(p);
  endtask

  task do_slave_monitor();
        wait(~rst_i);
        forever begin
            monitor_slave();
        end
  endtask

  // Slave
  task slave();
      fork
          do_slave_monitor();
      join
  endtask



  // Проверка
  task check(packet in, packet out);
      logic [WIDTH_Y:0] y1_expected = in.x1_i*W11 + in.x2_i*W12 + in.x3_i*W13

      if(out.y1_o !==  y1_expected)
        $error("[%0t] ERROR: input_data: x1=%0d,x2=%0d,x3=%0d expected: y1=%0d, got: y1=%0d",
            $time, in.x1_input, in.x2_input, in.x3_input, y1_expected, out.y1_o);
      else
        $display("[%0t] OK:  input_data: x1=%0d,x2=%0d,x3=%0d, res: y1=%0d",
          $time,  in.x1_input, in.x2_input, in.x3_input, out.y1_o);

      @(posedge clk_i);


      if(out.y1_o !==  y1_expected)
        $error("[%0t] ERROR: input_data: x1=%0d,x2=%0d,x3=%0d expected: y1=%0d, got: y1=%0d",
            $time, in.x1_input, in.x2_input, in.x3_input, y1_expected, out.y1_o);
      else
        $display("[%0t] OK:  input_data: x1=%0d,x2=%0d,x3=%0d, res: y1=%0d",
          $time,  in.x1_input, in.x2_input, in.x3_input, out.y1_o);


  endtask



  task do_check(int pkt_amount = 1);
      int cnt;
      packet in_p, out_p;
      forever begin
          in_mbx.get(in_p);
          out_mbx.get(out_p);
          check(in_p, out_p);
          cnt = cnt + out_p.tlast;
          if( cnt == pkt_amount ) begin
              break;
          end
      end
      $stop();
  endtask

  task error_checker(int pkt_amount = 1);
      do_check(pkt_amount);
  endtask


  //---------------------------------
  // Выполнение
  //---------------------------------

  // Генерация тактового сигнала
  initial begin
      clk <= 0;
      forever begin
          #(CLK_PERIOD/2) clk <= ~clk;
      end
  end


  task test(
        int gen_pkt_amount   = 100,   // количество пакетов
        int timeout_cycles   = 100000 // таймаут теста
    );
        fork
            master       (gen_pkt_amount);
            slave        ();
            error_checker(gen_pkt_amount);
            timeout      (timeout_cycles);
        join
    endtask

    initial begin
        fork
            reset();
        join_none
        test(
            .gen_pkt_amount (    100),
            .timeout_cycles (1000000)
        );
    end

endmodule
