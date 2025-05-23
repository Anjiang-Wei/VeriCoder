module JC_counter(
   input                clk,
   input                rst_n,
   output reg [63:0]     Q
);

// Define the initial value of the counter
always @* begin
    if (rst_n) begin
        Q <= 0; // Initialize the counter to 0
    end else begin
        case (Q[0]) {
            // Increment on least significant bit being 0
            if (Q[0] == 0) begin
                Q <= Q[63:1] >> 1 | 1; // Shift and append 1
            // Decrement on least significant bit being 1
            } else if (Q[0] == 1) begin
                Q <= Q[63:1] >> 1 & ~1; // Shift and subtract 1
            end
        }
    end
endmodule