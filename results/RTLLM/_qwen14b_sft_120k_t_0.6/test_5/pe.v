module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);
    // Accumulator register
    reg [31:0] c_reg;

    // Combinational logic to perform multiplication and accumulation
    always @(*) begin
        if (rst) begin
            c_reg = 32'b0; // Reset the accumulator to zero
        end else begin
            c_reg = c_reg + (a * b); // Accumulate the product of a and b
        end
    end

    // Output the accumulated result
    assign c = c_reg;
endmodule