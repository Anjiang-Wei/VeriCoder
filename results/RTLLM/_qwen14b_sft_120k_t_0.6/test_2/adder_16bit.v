module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire [15:0] carry;

    // Instantiate 8-bit adders for each 8-bit portion of the 16-bit adder
    adder_8bit adder_8bit_0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry[0])
    );
    adder_8bit adder_8bit_1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry[0]),
        .y(y[15:8]),
        .Co(carry[1])
    );

    // Assign the final carry-out
    assign Co = carry[1];
endmodule

// 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    genvar i;
    wire [7:0] carry;

    // Generate a full adder for each bit
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_gen
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .Cin((i == 0) ? Cin : carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    // Assign the final carry-out
    assign Co = carry[7];
endmodule

// Full adder module
module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire y,
    output wire Co
);
    wire sum, carry;

    // Sum and carry logic for a full adder
    assign sum = a ^ b ^ Cin;
    assign carry = (a & b) | (Cin & (a ^ b));
    assign y = sum;
    assign Co = carry;
endmodule