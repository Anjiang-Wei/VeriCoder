module pe(
    input             clk,    // system clock
    input             rst,    // async. active‐high reset
    input      [31:0] a,      // multiplicand
    input      [31:0] b,      // multiplier
    output reg [31:0] c       // 32‐bit accumulated result
);

    // On reset clear c, otherwise accumulate a*b every clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + a * b;
        end
    end

endmodule