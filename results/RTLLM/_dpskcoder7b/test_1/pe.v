module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

reg [31:0] c_reg;

always @(posedge clk or posedge rst)
begin
    if (rst)
        c_reg <= 32'b0;
    else
        c_reg <= c_reg + (a * b);
end

assign c = c_reg;

endmodule