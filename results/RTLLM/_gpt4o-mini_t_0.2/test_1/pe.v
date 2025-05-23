module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c
);

    // Accumulator register initialization
    initial begin
        c = 32'b0; // Initialize c to 0 at the beginning
    end

    // Always block triggered on the positive edge of clk or rst
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // If reset signal is high, clear the accumulator
            c <= 32'b0;
        end else begin
            // Accumulate the product of a and b
            c <= c + (a * b);
        end
    end

endmodule