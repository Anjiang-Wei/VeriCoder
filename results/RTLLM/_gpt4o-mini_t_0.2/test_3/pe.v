module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c
);

    // Initialize the accumulator register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // If reset is high, set the accumulator to 0
            c <= 32'b0;
        end else begin
            // Add the product of a and b to the current value of c
            c <= c + (a * b);
        end
    end

endmodule