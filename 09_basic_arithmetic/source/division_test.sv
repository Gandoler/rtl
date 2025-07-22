module division_test();
 parameter width = 4;
  logic [width-1:0] A, B;
  logic [width-1:0] Q, R;

  division #(width) dut (.*);
  
   initial begin
    $display("Starting division test...");
    
    
    A = 12; B = 3;
    #10000;
    $display("%0d / %0d = %0d, rem %0d %s", 
             A, B, Q, R, (Q === 4 && R === 0) ? "OK" : "ERROR");
    
    end
endmodule
