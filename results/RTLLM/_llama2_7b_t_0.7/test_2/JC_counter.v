module JC_counter(
   input                clk,
   input                rst_n,
 
   output reg [63:0]     Q
);

// Initialize the counter to 0 on reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 0;
    end else begin
        // Update the counter on every rising edge of the clock
        if (Q[0] == 0) begin
            Q <= Q >> 1 & ~rst_n; // Increment on least significant bit = 0
        end else begin
            Q <= Q >> 1 | rst_n; // Decrement on least significant bit = 1
        end
    end
end