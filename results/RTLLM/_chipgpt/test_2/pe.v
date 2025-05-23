module multiplier_with_accumulator(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

wire [31:0] c;
reg [31:0] c;
reg rst;
always @(posedge clk or posedge rst) begin
    if (rst) c <= 0;
    else c <= c + {a[31:24], b[31:24]} + a[23:0];
end
endmodule