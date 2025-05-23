module pe(
    input clk,  // Clock signal used for synchronous operations.
    input rst,  // Reset signal. Defined as 1 for reset and 0 for reset signal inactive.

    input [31:0] a,  // 32-bit input operand A.
    input [31:0] b,  // 32-bit input operand B.

    output reg [31:0] c  // 32-bit output representing the accumulated result.
);

// Register to store the partial sum (intermediate accumulation result).
reg [31:0] accumulator;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset condition: set the register to 0.
        accumulator <= '0;
        c <= '0;
    end else begin
        // Update the accumulator with the product of a and b, plus its current value.
        accumulator <= accumulator + (a * b);
        c <= accumulator;  // Assign the updated accumulator value to output c.
    end
end

endmodule