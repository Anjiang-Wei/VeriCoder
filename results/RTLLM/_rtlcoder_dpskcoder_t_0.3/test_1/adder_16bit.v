module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] sum1, sum2, sum3, sum4;
    wire carry1, carry2, carry3;

    adder_8bit adder1 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(sum1), .Co(carry1));
    adder_8bit adder2 (.a(a[15:8]), .b(b[15:8]), .Cin(carry1), .y(sum2), .Co(carry2));
    adder_8bit adder3 (.a(sum1), .b(sum2), .Cin(carry2), .y(sum3), .Co(carry3));
    adder_8bit adder4 (.a(sum3), .b(sum4), .Cin(carry3), .y(y), .Co(Co));

endmodule