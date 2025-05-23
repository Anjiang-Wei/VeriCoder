module top_module (
    input wire clk,
    input wire rst_n,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [7:0] C,
    output wire [7:0] result,
    output wire [7:0] odd
);

wire [15:0] A_extended;
wire [15:0] B_extended;
wire [15:0] C_extended;

assign A_extended = {8'b0, A};
assign B_extended = {8'b0, B};
assign C_extended = {8'b0, C};

div_16bit div1 (
    .A(A_extended),
    .B(B_extended),
    .result(result),
    .odd(odd)
);

div_16bit div2 (
    .A(C_extended),
    .B(B_extended),
    .result(result),
    .odd(odd)
);

endmodule