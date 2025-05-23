module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [15:0] carry;

    // 8-bit adder
    add8bit add1 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(carry[0]));
    add8bit add2 (.a(a[15:8]), .b(b[15:8]), .Cin(carry[0]), .y(y[15:8]), .Co(Co));

endmodule

// 8-bit full adder
module add8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

    wire [7:1] carry;

    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin), .y(y[0]), .Co(carry[0]));
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : each_bit
            full_adder fa (.a(a[i]), .b(b[i]), .Cin(carry[i-1]), .y(y[i]), .Co(carry[i]));
        end
    endgenerate
    assign Co = carry[7];

endmodule

// 1-bit full adder
module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire y,
    output wire Co
);

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (Cin & (a ^ b));

endmodule