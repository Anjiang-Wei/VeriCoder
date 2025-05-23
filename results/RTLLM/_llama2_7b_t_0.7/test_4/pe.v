module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

// Accumulator Register
reg [31:0] c; // Initialize accumulator register with zero

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0; // Reset accumulator to zero
    end else begin
        if (a == 0 && b == 0) begin
            // Special case for a=0 and b=0, which is undefined behavior in Verilog
            // but can be safely ignored here since we're only using this module as a building block
            c <= 0;
        end else begin
            c <= c + a * b; // Add product of a and b to accumulator
        end
    end
end

endmodule