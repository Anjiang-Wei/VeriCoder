module JC_counter(
   input                clk,
   input                rst_n,
   output reg [63:0]     Q
);

// Define the current count value
reg [63:0] current_count = 0;

// Initialize the counter with the given initial value
initial begin
    Q <= current_count;
end

// Clock signal handler
always@(posedge clk or negedge rst_n) begin
    // Reset the counter on reset signal
    if (rst_n) begin
        current_count <= 0;
    end else begin
        // Increment/decrement the counter on each clock edge
        case (current_count)
            0: current_count <= current_count + 1; // Increment
            -1: current_count <= current_count - 1; // Decrement
            default: current_count <= current_count >> 1; // Torsional ring counter update
        endcase
    end
end

// Output the current count value
output reg [63:0]     Q = current_count;

endmodule