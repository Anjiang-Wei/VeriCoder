module pe (
    input             clk,    // clock
    input             rst,    // active‐high reset
    input      [31:0] a,      // operand A
    input      [31:0] b,      // operand B
    output reg [31:0] c       // accumulated result
);

    // On reset, clear the accumulator.
    // Otherwise, on each rising clock edge, multiply a*b and add to c.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + a * b;
        end
    end

endmodule