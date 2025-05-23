module JC_counter(
   input                clk, // Clock signal used for synchronous operation
   input                rst_n, // Active-low reset signal to initialize the counter
   
   output reg [63:0]     Q  // 64-bit register representing the current count value
);

// Initialize the counter value to all zeros on reset
always @(posedge rst_n) begin
    if (!rst_n)
        Q <= 'b0;
end

// Update the counter value on every rising edge of the clock signal (clk)
always @(posedge clk) begin
    // If the least significant bit is 1, decrement by setting MSB to 0 and shifting right
    if (Q[0])
        Q[63:1] <= {Q[62], ~Q[63]};
    
    // If the least significant bit is 0, increment by setting MSB to 1 and shifting right
    else
        Q[63:1] <= {Q[62], 1'b1};
end

endmodule