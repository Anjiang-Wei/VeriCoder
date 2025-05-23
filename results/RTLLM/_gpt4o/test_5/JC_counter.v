module JC_counter(
   input                clk,    // Clock signal
   input                rst_n,  // Active-low reset signal
 
   output reg [63:0]    Q       // 64-bit register output
);

// Always block triggered on rising edge of clock or falling edge of reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // When reset is active (rst_n = 0), set the counter to zero
        Q <= 64'b0;
    end 
    else begin
        // Evaluate based on LSB of Q (Q[0])
        if (Q[0] == 0) begin
            // If the least significant bit is 0, increment the counter
            Q <= {1'b1, Q[63:1]};  // Shift right and append 1 at MSB
        end 
        else begin
            // If the least significant bit is 1, decrement the counter
            Q <= {1'b0, Q[63:1]};  // Shift right and append 0 at MSB
        end
    end
end

endmodule