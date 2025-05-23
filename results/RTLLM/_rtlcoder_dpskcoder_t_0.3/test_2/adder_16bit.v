module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    wire carry0, carry1, carry2, carry3, carry4, carry5, carry6;

    adder_8bit adder0(.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(sum0), .Co(carry0));
    adder_8bit adder1(.a(a[15:8]), .b(b[15:8]), .Cin(carry0), .y(sum1), .Co(carry1));
    adder_8bit adder2(.a(sum0), .b(sum1), .Cin(carry1), .y(sum2), .Co(carry2));
    adder_8bit adder3(.a(a[7:0]), .b(b[7:0]), .Cin(carry2), .y(sum3), .Co(carry3));
    adder_8bit adder4(.a(a[15:8]), .b(b[15:8]), .Cin(carry3), .y(sum4), .Co(carry4));
    adder_8bit adder5(.a(sum3), .b(sum4), .Cin(carry4), .y(sum5), .Co(carry5));
    adder_8bit adder6(.a(a[7:0]), .b(b[7:0]), .Cin(carry5), .y(sum6), .Co(carry6));
    adder_8bit adder7(.a(a[15:8]), .b(b[15:8]), .Cin(carry6), .y(sum7), .Co(Co));

    assign y = {sum7, sum5, sum6, sum2};

endmodule