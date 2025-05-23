module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire sum,
    output wire Cout
);
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (Cin & (a ^ b));
endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    wire [7:0] carry;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_gen
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .Cin((i == 0) ? Cin : carry[i-1]),
                .sum(y[i]),
                .Cout(carry[i])
            );
        end
    endgenerate

    assign Co = carry[7];
endmodule

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire [7:0] y_high, y_low;
    wire Co_low;

    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y_low),
        .Co(Co_low)
    );

    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_low),
        .y(y_high),
        .Co(Co)
    );

    assign y = {y_high, y_low};
endmodule