module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire [7:0] y0, y1, y2, y3;
    wire c0, c1, c2, c3;
    adder_8bit adder0 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y0), .Co(c0));
    adder_8bit adder1 (.a(a[15:8]), .b(b[15:8]), .Cin(c0), .y(y1), .Co(c1));
    adder_8bit adder2 (.a(a[7:0]), .b(b[7:0]), .Cin(c1), .y(y2), .Co(c2));
    adder_8bit adder3 (.a(a[15:8]), .b(b[15:8]), .Cin(c2), .y(y3), .Co(c3));
    assign y = {y3, y2, y1, y0};
    assign Co = c3;
endmodule