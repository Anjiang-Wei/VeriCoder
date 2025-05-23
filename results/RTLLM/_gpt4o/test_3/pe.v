module pe(
    input clk,                // Clock signal
    input rst,                // Reset signal (1 = reset, 0 = inactive)
    input [31:0] a,           // 32-bit input operand A
    input [31:0] b,           // 32-bit input operand B
    output reg [31:0] c       // 32-bit output register for accumulated result
);

    // Sequential logic: Update the accumulator (c) on the positive edge of clk or rst
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;                      // Reset the accumulator to 0
        end else begin
            c <= c + (a * b);                // Accumulate the product of 'a' and 'b'
        end
    end

endmodule