module JC_counter(
   input                clk ,
   input                rst_n,
 
   output reg [63:0]     Q  
);

// Define the initial value of the counter
initialization:
    Q = 0;

always@(posedge clk or negedge rst_n) begin
    // Update the counter value on rising edge of clock or falling edge of reset
    if (!rst_n && Q[0] == 0) begin
        // Increment the counter by shifting the current value to the right and appending a 1 at the most significant bit position
        Q = {Q[63:1], 1};
    end else if (!rst_n && Q[0] == 1) begin
        // Decrement the counter by shifting the current value to the right and appending a 0 at the most significant bit position
        Q = {Q[63:1], 0};
    end
end

endmodule