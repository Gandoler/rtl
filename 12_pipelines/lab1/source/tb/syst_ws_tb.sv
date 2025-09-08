module syst_ws_tb#(
  parameter WIDTH_X    = 7,
  parameter WIDTH_Y    = 18,
  parameter CLK_PERIOD = 10
)();

//---------------------------------
// Сигналы
//---------------------------------
  logic clk_i;
  logic rst_i;

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
  task timeout(input int timeout_cycles = 100000);
      repeat(timeout_cycles) @(posedge clk_i);
      $stop();
  endtask

// Master
  task gen_master(
      input int size_min   = 1,
      input int size_max   = 10
  );
    packet_in p;
    p.x1_i = $urandom_range(0,5);// 2**WIDTH_X-1
    p.x2_i = $urandom_range(0, 5);
    p.x3_i = $urandom_range(0, 5);
    gen2drv.put(p);

  endtask


  task do_master_gen(input
        int pkt_amount = 100
    );
        repeat(pkt_amount) begin
            gen_master();
        end
  endtask


  task reset_master();
        wait(rst_i);
        x1_i  <= 0;
        x2_i  <= 0;
        x3_i  <= 0;
        wait(~rst_i);
  endtask



  task drive_master(input packet_in p ,input int set_delay=2);
        x1_i  <= p.x1_i;
        x2_i  <= p.x2_i;
        x3_i  <= p.x3_i;
        repeat(set_delay)@(posedge clk_i);
  endtask


  task do_master_drive(input int set_delay=2);
        packet_in p;
        reset_master();
        @(posedge clk_i);
        forever begin
            gen2drv.get(p);
            drive_master(p,set_delay);
        end
  endtask


  task monitor_master(input int set_delay=2);
        packet_in p;
          p.x1_i  = x1_i;
          p.x2_i  = x2_i;
          p.x3_i  = x3_i;
          in_mbx.put(p);
  endtask


  task do_master_monitor(input int set_delay=2);
        wait(~rst_i);
        repeat(set_delay)@(posedge clk_i);
        forever begin
            monitor_master(set_delay);
            repeat(set_delay)@(posedge clk_i);
        end
  endtask

  // Master
  task master(
      input int gen_pkt_amount = 100,
      input int set_delay=2
  );
      fork
          do_master_gen(gen_pkt_amount);
          do_master_drive(set_delay);
          do_master_monitor(set_delay);
      join
  endtask


  // Slave
  task monitor_slave(input int set_delay=2);
        packet_out p;
        p.y1_o  = y1_o;
        @(posedge clk_i);
        p.y2_o  = y2_o;
        out_mbx.put(p);
  endtask

  task do_slave_monitor(input int set_delay=2);
        wait(~rst_i);
        if (set_delay !=3)
          $display("delay=%0d",set_delay);
          
        repeat(set_delay + 2)@(posedge clk_i);
        forever begin
            monitor_slave(set_delay);
            repeat(set_delay-1)@(posedge clk_i);
        end
  endtask

  // Slave
  task slave(input int set_delay=2);
      fork
          do_slave_monitor(set_delay);
      join
  endtask



  // Проверка
  task check_01(packet_in in_prev, packet_out out);
      logic [WIDTH_Y:0] y1_expected;
      logic [WIDTH_Y:0] y2_expected;

      y1_expected = in_prev.x1_i * W11 + in_prev.x2_i * W12 + in_prev.x3_i * W13;
      y2_expected = in_prev.x1_i * W21 + in_prev.x2_i * W22 + in_prev.x3_i * W23;


      if(out.y1_o !==  y1_expected)
        $error("[%0t] ERROR: input_data: x1=%0d,x2=%0d,x3=%0d expected: y1=%0d, got: y1=%0d",
            $time, in_prev.x1_i, in_prev.x2_i, in_prev.x3_i, y1_expected, out.y1_o);
      else
        $display("[%0t] OK:  input_data: x1=%0d,x2=%0d,x3=%0d, res: y1=%0d",
          $time,  in_prev.x1_i, in_prev.x2_i, in_prev.x3_i, out.y1_o);

      if(out.y2_o !==  y2_expected)
        $error("[%0t] ERROR: input_data: x1=%0d,x2=%0d,x3=%0d expected: y2=%0d, got: y2=%0d\n",
            $time, in_prev.x1_i, in_prev.x2_i, in_prev.x3_i, y2_expected, out.y2_o);
      else
        $display("[%0t] OK:  input_data: x1=%0d,x2=%0d,x3=%0d, res: y2=%0d\n",
          $time,  in_prev.x1_i, in_prev.x2_i, in_prev.x3_i, out.y2_o);


  endtask



  task do_check(input int pkt_amount = 1);
      int cnt;
      packet_in in_p;
      packet_out out_p;


      forever begin
          in_mbx.get(in_p);
          out_mbx.get(out_p);
          //$display("Input x1=%0d x2=%0d x3=%0d",in_p.x1_i, in_p.x2_i, in_p.x3_i);
          //$display("Output y1=%0d y2=%0d",out_p.y1_o, out_p.y2_o);

          check_01(in_p, out_p);
          cnt        = cnt + 1;
          if( cnt == pkt_amount ) begin
              break;
          end
      end
      $stop();
  endtask

  task error_checker(input int pkt_amount = 1);
      do_check(pkt_amount);
  endtask


  //---------------------------------
  // Выполнение
  //---------------------------------

  // Генерация тактового сигнала
  initial begin
      clk_i <= 0;
      forever begin
          #(CLK_PERIOD/2) clk_i <= ~clk_i;
      end
  end


  task test(
        input int gen_pkt_amount   = 100,    // количество пакетов
        input int timeout_cycles   = 100000, // таймаут теста
        input int set_delay        = 2
    );
        fork
            master       (gen_pkt_amount, set_delay);
            slave        (set_delay);
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
            .timeout_cycles (1000000),
            .set_delay(3)
        );
    end

endmodule
