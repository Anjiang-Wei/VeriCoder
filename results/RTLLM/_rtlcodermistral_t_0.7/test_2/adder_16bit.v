// 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    assign {Co, y} = a + b + Cin;
endmodule