module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);
    // Accumulator register
    reg [31:0] c_reg;

    // Always block for synchronous operations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_reg <= 32'b0; // Reset the accumulator
        end else begin
            c_reg <= c_reg + (a * b); // Accumulate the product
        end
    end

    // Continuous assignment to output c
    assign c = c_reg;
endmodule