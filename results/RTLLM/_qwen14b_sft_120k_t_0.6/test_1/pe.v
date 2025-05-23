module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

reg [31:0] c_reg;

// Synchronous operation on the positive edge of the clock or reset signal
always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'b0; // Reset the accumulator to 0
    end else begin
        c_reg <= c_reg + (a * b); // Accumulate the product of a and b
    end
end

// Assign the register to the output
assign c = c_reg;

endmodule