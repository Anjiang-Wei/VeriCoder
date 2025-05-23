module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c // Output declared as reg for continuous value updates
);

    // Register to store the accumulated result
    reg [31:0] accumulator;

    // Always block triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset condition: Set accumulator and output to 0
            accumulator <= 32'b0;
            c <= 32'b0;
        end else begin
            // No reset: Accumulate the product of a and b
            accumulator <= accumulator + (a * b);
            c <= accumulator; // Update output with the accumulated value
        end
    end

endmodule