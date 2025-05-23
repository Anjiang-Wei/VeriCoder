// Define the 8-bit adder module
    module adder_8bit (
        input wire [7:0] a,
        input wire [7:0] b,
        input wire Cin,
        output wire [7:0] y,
        output wire Co
    );

    // Implement the 8-bit adder here
    endmodule

    // Instantiate the 8-bit adders
    wire [7:0] sum_lo;
    wire carry_lo;
    wire [7:0] sum_mid;
    wire carry_mid;
    wire [7:0] sum_hi;
    wire carry_hi;

    adder_8bit low (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(sum_lo), .Co(carry_lo));
    adder_8bit mid  (.a(a[15:8]), .b(b[15:8]), .Cin(carry_lo), .y(sum_mid), .Co(carry_mid));
    adder_8bit high (.a(sum_mid), .b(sum_lo), .Cin(carry_mid), .y(y[15:0]), .Co(Co));