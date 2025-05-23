module eight_bit_adder (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

    wire [7:0] sum;
    wire C1, C2, C3;

    // First stage
    full_adder FA1(a[0], b[0], Cin, sum[0], C1);
    // Second stage
    full_adder FA2(a[1], b[1], C1, sum[1], C2);
    // Third stage
    full_adder FA3(a[2], b[2], C2, sum[2], C3);
    // Fourth stage
    full_adder FA4(a[3], b[3], C3, sum[3], Co);
    // Fifth stage
    full_adder FA5(a[4], b[4], Co, sum[4], Co);
    // Sixth stage
    full_adder FA6(a[5], b[5], Co, sum[5], Co);
    // Seventh stage
    full_adder FA7(a[6], b[6], Co, sum[6], Co);
    // Eighth stage
    full_adder FA8(a[7], b[7], Co, sum[7], Co);

    assign y = sum;

endmodule