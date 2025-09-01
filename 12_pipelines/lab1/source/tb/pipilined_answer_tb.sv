module pipilined_answer_tb#(
  parameter DATA_WIDTH = 8
)();
 logic                      clk_i,
 logic                      rst_i,
 logic [DATA_WIDTH-1:0]     pow_data_i,
 logic                      data_valid_i,
 logic [(5*DATA_WIDTH)-1:0] pow_data_o,
 logic                      data_valid_o

  parameter CLK_PERIOD = 10;

  initial begin
      clk <= 0;
      forever begin
          #(CLK_PERIOD/2) clk = ~clk;// Пишите тут.
      end
  end

  initial begin
      aresetn <= 0;
      #(CLK_PERIOD);
      aresetn <= 1;
  end

  initial begin
    wait(aresetn);

  end

  typedef struct {
        logic       [DATA_WIDTH-1:0] pow_data_i ;
        logic       [3:0] data_valid_i;
        logic       [3:0] out;
    } packet;

    mailbox#(packet) mon2chk = new();



endmodule
