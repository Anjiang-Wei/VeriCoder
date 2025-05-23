// Module name: adder_8bit (basic unit)
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

    // Logic for 8-bit full adder
    assign y = {a[3]^b[3], a[2]^b[2]^Cin, 
                a[1]^b[1]^Cin, a[0]^b[0]^Cin};
    assign Co = a[7]^b[7]^y[7];
endmodule

// Module name: adder_16bit (main module)
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Divide the operands into two 8-bit parts each
    reg [7:0] a_lo, a_hi;
    reg [7:0] b_lo, b_hi;

    assign {a_lo, a_hi} = a[7:0];
    assign {b_lo, b_hi} = b[7:0];

    // Instantiate the 8-bit full adder for each part
    adder_8bit adder1 ( 
        .a(a_lo), 
        .b(b_lo), 
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co1)
    );

    assign {y[15:8], Co} = {a_hi, b_hi, Co1};
endmodule