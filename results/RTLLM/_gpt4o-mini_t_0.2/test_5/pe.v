module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c
);

// Internal register for accumulating the result
reg [31:0] acc;

// Always block for synchronous operations
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset condition
        acc <= 32'b0; // Initialize accumulator to 0
    end else begin
        // Multiply and accumulate
        acc <= acc + (a * b); // Update accumulator with the product of a and b
    end
end

// Assign the accumulated value to output c
always @(posedge clk) begin
    c <= acc; // Output the current value of the accumulator
end

endmodule