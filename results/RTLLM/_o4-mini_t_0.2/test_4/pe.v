module pe (
    input            clk,   // clock
    input            rst,   // synchronous reset (active high)
    input      [31:0] a,    // multiplicand
    input      [31:0] b,    // multiplier
    output reg [31:0] c     // accumulated result
);

    // 32-bit truncated product
    wire [31:0] product;
    assign product = a * b;

    // on reset, clear accumulator; else accumulate product
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            c <= c + product;
        end
    end

endmodule