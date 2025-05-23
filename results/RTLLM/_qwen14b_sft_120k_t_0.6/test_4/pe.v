module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

    reg [31:0] c_reg;

    // Always block triggered on the positive edge of clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_reg <= 32'b0;  // Clear the accumulator on reset
        end else begin
            c_reg <= c_reg + (a * b);  // Accumulate the product of a and b
        end
    end

    assign c = c_reg;  // Output the accumulated result

endmodule