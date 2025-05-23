module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

// Accumulator Register
reg [31:0] c;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0; // Reset the accumulator register
    end else begin
        c <= c + a * b; // Update the accumulator register with the product of A and B
    end
end

// Multiplication and Accumulation
always @* begin
    if (rst) begin
        // Set the accumulator register to 0
        c <= 0;
    end else begin
        // Add the product of A and B to the accumulator register
        c <= c + a * b;
    end
end