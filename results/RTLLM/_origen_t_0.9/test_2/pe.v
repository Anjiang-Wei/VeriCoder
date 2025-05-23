module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c
);

    // Intermediate wire to store the product of a and b
    wire [63:0] product;

    // Multiplication operation
    assign product = a * b;

    // Accumulator logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            c <= c + product[31:0];
        end
    end

endmodule