module JC_counter (
    // Input Ports
    input                  clk,         // Clock signal used for synchronous operation.
    input                  rst_n,       // Active-low reset signal to initialize the counter.

    // Output Port
    output reg [63:0]      Q           // 64-bit register representing the current count value.
);

// Reset Logic
always @(posedge rst_n or posedge clk) begin
    if (~rst_n) begin
        Q <= 'h00000000000000000000000000000000; // Initialize counter to 0 when reset is active
    end
end

// Counter Logic
always @(posedge clk) begin
    case (Q[63:0])
        'h00000000000000000000000000000000, 'h10000000000000000000000000000000, 
        'h11000000000000000000000000000000, 'h11100000000000000000000000000000,
        'h11110000000000000000000000000000, 'h01110000000000000000000000000000,
        'h00110000000000000000000000000000, 'h00010000000000000000000000000000: begin
            // Increment counter by shifting current value right and appending 1 at MSB
            Q <= {1'b0, Q[63:2]};
        end
        default: begin
            // Decrement counter by shifting current value right and appending 0 at MSB
            Q <= {1'b1, Q[63:1]};
        end
    endcase
end

// End of Module JC_counter
endmodule