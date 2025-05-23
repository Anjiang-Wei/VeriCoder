module pe(
    input        clk,
    input        rst,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] c
);

    // On reset, clear accumulator.
    // Otherwise, multiply a and b each cycle and add to c.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + a * b;
        end
    end

endmodule