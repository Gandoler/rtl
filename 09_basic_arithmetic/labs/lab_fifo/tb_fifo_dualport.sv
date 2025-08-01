`timescale 1ns/1ps

module tb_fifo_dualport;

  parameter WIDTH = 8;
  parameter DEPTH = 8;

  logic clk_i;
  logic rst_i;

  logic                  valid_i;
  logic                  ready_i;
  logic [WIDTH-1:0]      data_i;
  logic [WIDTH-1:0]      data_o;
  logic                  ready_o;
  logic                  valid_o;

  fifo_dualport #(
    .WIDTH (WIDTH),
    .DEPTH (DEPTH)
  ) dut (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .valid_i  (valid_i),
    .ready_i  (ready_i),
    .data_i   (data_i),
    .data_o   (data_o),
    .ready_o  (ready_o),
    .valid_o  (valid_o)
  );


  logic [WIDTH-1:0] push_data_array [0:15];


initial
   clk_i = 'b0;
    always #5 clk_i = ~clk_i;
  initial begin
    rst_i = 'b1;
    #50;
    rst_i = 'b0;


    for (int i = 0; i < 16; i++) begin
      push_data_array[i] = i;
    end




    valid_i = 'b0;
    ready_i = 'b0;
    data_i  = 'b0;


    $display("[TEST] Simple push/pop");
    do_push(push_data_array[0]);
    do_pop(push_data_array[0]);
     if ( data_o !== push_data_array[0])
       $error("Mismatch: expected %0d, got %0d", push_data_array[0], data_o);
//    do_pop();
//    if (int i !== push_data_array[0])
//      $error("Mismatch: expected %0d, got %0d", push_data_array[0], i);

//    $display("[TEST] Fill until full");
//    for (int i = 0; i < DEPTH; i++) begin
//      do_push(push_data_array[i]);
//    end
//    if (!ready_o)
//      $error("FIFO should be full: ready_o is low");
//    do_push('hFF);
//    if (ready_o)
//      $error("FIFO accepted data when full");

//    $display("[TEST] Drain FIFO");
//    for (int i = 0; i < DEPTH; i++) begin
//      do_pop(data_i);
//      if (data_i !== push_data_array[i])
//        $error("Error at pop %0d: expected %0d, got %0d", i, push_data_array[i], data_i);
//    end
//    @(posedge clk_i);
//    if (valid_o)
//      $error("FIFO valid asserted when empty");

//    $display("[TEST] Wrap-around behavior");
//    for (int i = 0; i < DEPTH/2; i++) do_push(push_data_array[i]);
//    for (int i = 0; i < DEPTH/4; i++) do_pop(data_i);
//    for (int i = DEPTH/2; i < DEPTH/2 + DEPTH/2; i++) do_push(push_data_array[i]);
//    while (valid_o) begin
//      do_pop(data_i);
//    end

//    $display("[TEST] All tests completed");
//    $finish;

//    $dumpfile("tb_fifo_dualport.vcd");
//    $dumpvars(0, tb_fifo_dualport);
  end



task automatic do_push(input [WIDTH-1:0] val);
    begin
      @(posedge clk_i);
      valid_i <= 1;
      data_i  <= val;

      wait (ready_o == 1);
      @(posedge clk_i);
      valid_i <= 0;
    end
  endtask


  task automatic do_pop(output [WIDTH-1:0] val);
    begin
      @(posedge clk_i);
      ready_i <= 1;
      wait (valid_o == 1);
      @(posedge clk_i);
      val     = data_o;
      ready_i <= 0;
    end
  endtask


endmodule
