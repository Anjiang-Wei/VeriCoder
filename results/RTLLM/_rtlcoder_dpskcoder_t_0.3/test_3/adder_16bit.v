module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] a_lo, a_hi, b_lo, b_hi;
    wire [7:0] sum_lo, sum_hi;
    wire carry_lo, carry_hi;

    assign {a_hi, a_lo} = a;
    assign {b_hi, b_lo} = b;

    adder_8bit adder_lo (.a(a_lo), .b(b_lo), .Cin(Cin), .y(sum_lo), .Co(carry_lo));
    adder_8bit adder_hi (.a(a_hi), .b(b_hi), .Cin(carry_lo), .y(sum_hi), .Co(Co));

    assign y = {sum_hi, sum_lo};

endmodule