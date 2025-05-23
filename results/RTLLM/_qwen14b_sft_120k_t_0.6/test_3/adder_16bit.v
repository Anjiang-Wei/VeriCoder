module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Declare an 8-bit adder module
    module adder_8bit (
        input wire [7:0] a,
        input wire [7:0] b,
        input wire Cin,
        output wire [7:0] sum,
        output wire Co
    );
        wire [7:0] carry;
        assign carry[0] = Cin;
        genvar i;
        generate
            for (i = 0; i < 8; i = i + 1) begin : gen_adder
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
            end
        endgenerate
        assign Co = carry[8];
    endmodule

    // Instantiate 2x 8-bit adders and connect them to form a 16-bit adder
    wire [7:0] sum1, sum2, carry1, carry2;

    adder_8bit adder1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(sum1),
        .Co(carry1)
    );

    adder_8bit adder2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry1),
        .sum(sum2),
        .Co(Co)
    );

    assign y = {sum2, sum1};
endmodule