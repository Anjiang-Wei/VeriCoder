module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

// Accumulator Register
always @(*)
begin
    if (rst)
        c <= 0;
    else
        c <= c + a * b;
end

// Multiplication and Accumulation
always @(posedge clk or posedge rst)
begin
    if (rst)
        c <= 0;
    else
        c <= c + a * b;
end

endmodule