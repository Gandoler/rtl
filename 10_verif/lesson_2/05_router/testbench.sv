module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    logic       [3:0] expected_out;

    // Остальные сигналы
    logic       [1:0] sel  [0:3];
    logic       [3:0] in;
    logic       [3:0] out;

    router DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .sel     ( sel     ),
        .in      ( in      ),
        .out     ( out     )
    );

    // TODO:
    // Найдите все ошибки в модуле ~router~

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 10;// ?;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
          #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    // TODO:
    // Cгенерируйте сигнал сброса
    initial begin
      aresetn <= 0;
      #(CLK_PERIOD);
      aresetn <= 1;
    end

    // TODO:
    // Сгенерируйте входные сигналы
    // Не забудьте про ожидание сигнала сброса!
    initial begin
      // Входные воздействия опишите здесь.
      wait(aresetn);
      for(int i = 0; i < 100; i++) begin
        @(posedge clk);
        in <= $urandom();
        for(int j = 0; j < 4; j++) begin
          sel[j] <= $urandom();
        end
      end
      $stop();
    end

    // Пользуйтесь этой структурой
    typedef struct {
        logic       [1:0] sel [0:3];
        logic       [3:0] in;
        logic       [3:0] out;
    } packet;

    mailbox#(packet) mon2chk = new();

    // TODO:
    // Сохраняйте сигналы каждый положительный
    // фронт тактового сигнала
    initial begin
        packet pkt;
        wait(aresetn);
        forever begin
            @(posedge clk);
            pkt.sel = sel;
            pkt.in  = in;
            pkt.out = out;
            mon2chk.put(pkt);
        end
    end


    initial begin
        packet pkt_prev, pkt_cur;
        wait(aresetn);
        mon2chk.get(pkt_prev);
        forever begin
            mon2chk.get(pkt_cur);
            // Пишите здесь
            expected_out ='b0;
            for(int i = 4; i > 0; i--)begin
              expected_out[pkt_prev.sel[i]] = pkt_prev.in[i];
            end

            if (pkt_cur.out != expected_out)
             $error("error in route");
            pkt_prev = pkt_cur;
        end
    end


endmodule
