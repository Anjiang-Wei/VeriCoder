module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);
    // Internal wire to hold the product of a and b
    wire [63:0] product;

    // Multiplier to compute the product of a and b
    assign product = a * b;

    // Always block to handle the clock and reset signals
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the register c to 0 when rst is high
            c <= 32'b0;
        end else begin
            // Accumulate the product into the register c
            c <= c + product[31:0];
        end
    end
endmodule