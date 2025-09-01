module faulty_counter (
    input  logic clk,
    input  logic rst_n,
    output logic [7:0] count
);

    logic [7:0] cnt;

    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    assign count = cnt;

endmodule
