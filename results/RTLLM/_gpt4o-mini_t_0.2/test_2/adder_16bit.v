// 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] sum,
    output wire Cout
);
    assign {Cout, sum} = a + b + Cin; // Simple addition with carry-out
endmodule

// 16-bit adder module
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] sum_lower;
    wire [7:0] sum_upper;
    wire carry_lower;
    wire carry_upper;

    // Instantiate the lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(sum_lower),
        .Cout(carry_lower)
    );

    // Instantiate the upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_lower), // Carry from the lower 8-bit adder
        .sum(sum_upper),
        .Cout(Co) // Carry-out from the upper 8-bit adder
    );

    // Combine the results to form the final output
    assign y = {sum_upper, sum_lower}; // Concatenate upper and lower results

endmodule