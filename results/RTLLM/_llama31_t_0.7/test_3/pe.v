module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

reg [31:0] accumulator; // accumulator register

always @(posedge clk or posedge rst) begin
    if (rst)
        accumulator <= 32'd0;
    else
        accumulator <= accumulator + a * b;
end

assign c = accumulator;

endmodule