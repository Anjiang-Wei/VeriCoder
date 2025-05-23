module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

// Accumulator register
reg [31:0] c;

always@(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0;
    end else begin
        c <= c + a * b;
    end
end

// Multiplication and accumulation
always@* begin
    // Multiply A and B
    multiply(a, b, product);

    // Accumulate result in C
    if (rst) begin
        c <= 0;
    end else begin
        c <= c + product;
    end
end

endmodule