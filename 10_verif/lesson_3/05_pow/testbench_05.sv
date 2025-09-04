`timescale 1ns/1ps

module testbench_05;


    //---------------------------------
    // Сигналы
    //---------------------------------

    logic        clk;
    logic        aresetn;

    logic        s_tvalid;
    logic        s_tready;
    logic [31:0] s_tdata;
    logic        s_tid;
    logic        s_tlast;

    logic        m_tvalid;
    logic        m_tready;
    logic [31:0] m_tdata;
    logic        m_tid;
    logic        m_tlast;


    //---------------------------------
    // Модуль для тестирования
    //---------------------------------

    pow_05 DUT(
        .clk      ( clk       ),
        .aresetn  ( aresetn   ),
        .s_tvalid ( s_tvalid  ),
        .s_tready ( s_tready  ),
        .s_tdata  ( s_tdata   ),
        .s_tid    ( s_tid     ),
        .s_tlast  ( s_tlast   ),
        .m_tvalid ( m_tvalid  ),
        .m_tready ( m_tready  ),
        .m_tdata  ( m_tdata   ),
        .m_tid    ( m_tid     ),
        .m_tlast  ( m_tlast   )
    );


    //---------------------------------
    // Переменные тестирования
    //---------------------------------

    // Период тактового сигнала
    parameter CLK_PERIOD = 10;

    // Пакет и mailbox'ы
    typedef struct {
        int          delay;
        logic [31:0] tdata;
        logic        tid;
        logic        tlast;
    } packet;

    mailbox#(packet) gen2drv = new();
    mailbox#(packet) in_mbx  = new();
    mailbox#(packet) out_mbx = new();


    //---------------------------------
    // Методы
    //---------------------------------

    // Генерация сигнала сброса
    task reset();
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    endtask

    // Таймаут теста
    task timeout(input int timeout_cycles = 1000000);
        repeat(timeout_cycles) @(posedge clk);
        $stop();
    endtask

    // Master
    task gen_master(
        input int size_min   = 1,
        input int size_max   = 10,
        input int delay_min  = 0,
        input int delay_max  = 10
    );
        packet p;
        int size;
        void'(std::randomize(size) with {size inside {[size_min:size_max]};});
        for(int i = 0; i < size; i = i + 1) begin
            p.delay = $urandom_range(delay_min, delay_max);            
            p.tlast = (i == size - 1);
            p.tdata = $urandom();
            p.tid   = $urandom_range(0, 1);
            gen2drv.put(p);
        end
    endtask

    task do_master_gen(
        input int pkt_amount = 100,
        input int size_min   = 1,
        input int size_max   = 10,
        input int delay_min  = 0,
        input int delay_max  = 10
    );
        repeat(pkt_amount) begin
            gen_master(size_min, size_max, delay_min, delay_max);
        end
    endtask

    task reset_master();
        wait(~aresetn);
        s_tvalid <= 0;
        s_tdata  <= 0;
        s_tid    <= 0;
        wait(aresetn);
    endtask

    task drive_master(packet p);
        repeat(p.delay) @(posedge clk);
        s_tvalid <= 1;
        s_tdata  <= p.tdata;
        s_tid    <= p.tid;
        s_tlast  <= p.tlast;
        do begin
            @(posedge clk);
        end
        while(~s_tready);
        s_tvalid <= 0;
        s_tlast  <= 0;
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
        if( s_tvalid & s_tready ) begin
            p.tdata  = s_tdata;
            p.tid    = s_tid;
            p.tlast  = s_tlast;
            in_mbx.put(p);
        end
    endtask

    task do_master_monitor();
        wait(aresetn);
        forever begin
            monitor_master();
        end
    endtask

    // Master
    task master(
        input int gen_pkt_amount = 100,
        input int gen_size_min   = 1,
        input int gen_size_max   = 10,
        input int gen_delay_min  = 0,
        input int gen_delay_max  = 10
    );
        fork
            do_master_gen(gen_pkt_amount, gen_size_min, gen_size_max, gen_delay_min, gen_delay_max);
            do_master_drive();
            do_master_monitor();
        join
    endtask

    // Slave
    task reset_slave();
        wait(~aresetn);
        m_tready <= 0;
        wait(aresetn);
    endtask

    task drive_slave(input int delay = 0);
        repeat(delay) @(posedge clk);
        m_tready <= 1;
        @(posedge clk);
        m_tready <= 0;
    endtask

    task do_slave_drive(input int slave_delay_min  = 0,     // минимальная задержка для slave
                        input int slave_delay_max  = 10);   // максимальная задержка для slave););
        reset_slave();
        @(posedge clk);
        forever begin
            drive_slave($urandom_range(slave_delay_min, slave_delay_max));
        end
    endtask

    task monitor_slave();
        packet p;
        @(posedge clk);
        if( m_tvalid & m_tready ) begin
            p.tdata  = m_tdata;
            p.tid    = m_tid;
            p.tlast  = m_tlast;
            out_mbx.put(p);
        end
    endtask

    task do_slave_monitor();
        wait(aresetn);
        forever begin
            monitor_slave();
        end
    endtask

    // Slave
    task slave(input int slave_delay_min  = 0,     // минимальная задержка для slave
               input int slave_delay_max  = 10);   // максимальная задержка для slave);
        fork
            do_slave_drive(slave_delay_min, slave_delay_max);
            do_slave_monitor();
        join
    endtask

    // Проверка
    task check(packet in, packet out);
        if( in.tid !== out.tid ) begin
            $error("%0t Invalid TID: Real: %h, Expected: %h",
                $time(), out.tid, in.tid);
        end
        if( out.tdata !== in.tdata ** 5 ) begin
            $error("%0t Invalid TDATA: Real: %0d, Expected: %0d ^ 5 = %0d",
                $time(), out.tdata, in.tdata, in.tdata ** 5);
        end
        if( in.tlast !== out.tlast ) begin
            $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                $time(), out.tlast, in.tlast);
        end
    endtask

    task do_check(input int pkt_amount = 1);
        int cnt;
        packet in_p, out_p;
        forever begin
            in_mbx.get(in_p);
            out_mbx.get(out_p);
            check(in_p, out_p);
            cnt = cnt + out_p.tlast;
            if(out_p.tlast) $display("cnt = %d", cnt);
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
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    // TODO:
    // Реализуйте логику для максимальной и минимальной
    // задержки сигнала tready для slave.
    // Обратите внимание, что в ходе запуска "как есть",
    // тестбенч не скомпилируется из-за несовпадения
    // количества аргументов в задаче slave()
    task test(
        input int gen_pkt_amount   = 50,   // количество пакетов
        input int gen_size_min     = 1,     // мин. размер пакета
        input int gen_size_max     = 10,    // макс. размер пакета
        input int gen_delay_min    = 0,     // мин. задержка между транзакциями
        input int gen_delay_max    = 10,    // макс. задержка между транзакциями
        input int slave_delay_min  = 0,     // минимальная задержка для slave
        input int slave_delay_max  = 10,    // максимальная задержка для slave
        input int timeout_cycles   = 1000000 // таймаут теста
    );
        fork
            master       (gen_pkt_amount, gen_size_min, gen_size_max, gen_delay_min, gen_delay_max);
            slave        (slave_delay_min, slave_delay_max);
            error_checker(gen_pkt_amount);
            timeout      (timeout_cycles);
        join
    endtask

    initial begin
        fork
            reset();
        join_none
        test(
            .gen_pkt_amount (   100),
            .gen_size_min   (    20),
            .gen_size_max   (   300),
            .gen_delay_min  (    10),
            .gen_delay_max  (    20),
            .slave_delay_min(     0),
            .slave_delay_max(     5),
            .timeout_cycles (1000000)
        );
    end

endmodule
