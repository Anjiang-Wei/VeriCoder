module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c
);

// Intermediate product
wire [63:0] product;

// Calculate the product of a and b
assign product = a * b;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'b0;  // Reset condition: clear the accumulator
    end else begin
        c <= c + product[31:0]; // Accumulate the lower 32 bits of the product
    end
end

endmodule