module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

// Accumulator Register
reg [31:0] c; // Initialize the register with 0

always@(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0; // Reset the accumulator to 0
    end else begin
        c <= c + a * b; // Update the accumulator with the product of A and B
    end
end

endmodule