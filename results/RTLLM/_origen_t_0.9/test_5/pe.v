module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

    reg [31:0] c_reg;
    wire [31:0] product;

    assign product = a * b;
    assign c = c_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_reg <= 32'b0;
        end else begin
            c_reg <= c_reg + product;
        end
    end

endmodule