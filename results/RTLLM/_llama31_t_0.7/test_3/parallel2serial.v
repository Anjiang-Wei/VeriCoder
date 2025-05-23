module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out = 1'b0,
    output reg dout
);

reg [2:0] cnt;
reg [3:0] data;

always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        cnt <= 3'd0; // Reset counter on active-low reset
        valid_out <= 1'b0; // Reset valid signal on active-low reset
        dout <= d[3]; // Load most significant bit of parallel input to serial output
    end else if (cnt == 3) begin
        data <= d;
        cnt <= 3'd0; // Reset counter when all bits are processed
        valid_out <= 1'b1; // Set valid signal when all bits are processed
    end else begin
        cnt <= cnt + 1'd1; // Increment counter on each clock cycle
        valid_out <= 1'b0; // Clear valid signal between bit processing cycles

        if (cnt == 3) begin
            dout <= d[2]; // Output second most significant bit of parallel input
        end else if (cnt == 2) begin
            dout <= d[1]; // Output third most significant bit of parallel input
        end else if (cnt == 1) begin
            dout <= d[0]; // Output least significant bit of parallel input
        end
    end

    if (rst_n == 1'b1 && cnt > 3) begin
        cnt <= cnt + 1'd1; // Increment counter on reset when not processing bits
    end
end

endmodule