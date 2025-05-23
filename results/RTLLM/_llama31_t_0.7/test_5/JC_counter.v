// Module name
module JC_counter (
    // Input ports
    input clk,        // Clock signal used for synchronous operation.
    input rst_n        // Active-low reset signal to initialize the counter.

    // Output port
    output reg [63:0] Q  // 64-bit register representing the current count value.
);

// Always block that updates the counter on every rising edge of clk or falling edge of rst_n
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin // Reset condition, set Q to 0
        Q <= 64'd0;
    end else begin
        if (Q[63]) begin // If least significant bit is 1 (i.e., most significant bit is 0), decrement counter
            Q <= {1'b0, Q[62:0]};
        end else begin // Otherwise, increment counter
            Q <= {1'b1, Q[63:1]};
        end
    end
end

endmodule // module JC_counter