module pe(
    input clk,             // Clock signal
    input rst,             // Reset signal (active high)
    input [31:0] a,        // 32-bit input operand A
    input [31:0] b,        // 32-bit input operand B
    output reg [31:0] c    // 32-bit output representing the accumulated result
);

    // Always block for synchronous operations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // On reset, clear the accumulator register
            c <= 32'b0;
        end else begin
            // On clock edge, perform multiplication and accumulate the result
            c <= c + (a * b);
        end
    end

endmodule