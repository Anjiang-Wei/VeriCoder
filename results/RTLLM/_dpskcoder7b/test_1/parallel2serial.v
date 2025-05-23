module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

// Define the counter register
reg [1:0] cnt;

// Define the data register
reg [3:0] data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset
        cnt <= 2'b00;
        valid_out <= 1'b0;
        dout <= 1'b0;
        data <= 4'b0000;
    end else begin
        // Synchronous operations
        if (cnt == 2'b11) begin
            // If the counter is 3, update the data register and reset the counter
            data <= d;
            cnt <= 2'b00;
            valid_out <= 1'b1;
        end else begin
            // Otherwise, increment the counter and shift the data register
            cnt <= cnt + 2'b01;
            valid_out <= 1'b0;
            dout <= data[3];
            data <= data << 1;
        end
    end
end
endmodule