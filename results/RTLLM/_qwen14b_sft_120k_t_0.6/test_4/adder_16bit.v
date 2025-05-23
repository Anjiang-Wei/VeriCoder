module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Declare an 8-bit adder module
    wire [7:0] sum_8bit0, sum_8bit1;
    wire Co0, Co1;
    
    // Instantiate two 8-bit adders
    adder_8bit adder0 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .sum(sum_8bit0), .Co(Co0));
    adder_8bit adder1 (.a(a[15:8]), .b(b[15:8]), .Cin(Co0), .sum(sum_8bit1), .Co(Co1));

    // Assign outputs
    assign y = {sum_8bit1, sum_8bit0};
    assign Co = Co1;

endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] sum,
    output wire Co
);
    // Declare wires for intermediate results
    wire [7:0] sum_1, sum_2, sum_3;
    wire Co1, Co2, Co3;

    // Full adders for each bit
    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin), .sum(sum_1[0]), .Co(Co1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(Co1), .sum(sum_1[1]), .Co(Co2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(Co2), .sum(sum_1[2]), .Co(Co3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(Co3), .sum(sum_1[3]), .Co(Co1[0]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .Cin(Co1[0]), .sum(sum_1[4]), .Co(Co2[0]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .Cin(Co2[0]), .sum(sum_1[5]), .Co(Co3[0]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .Cin(Co3[0]), .sum(sum_1[6]), .Co(Co1[1]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .Cin(Co1[1]), .sum(sum_1[7]), .Co(Co2[1]));

    // Combinational logic for carry generation
    assign Co1[1] = Co3[0];
    assign Co2[1] = Co1[1];
    assign Co3[1] = Co2[1];

    // Combinational logic for sum generation
    assign sum_2[0] = sum_1[0];
    assign sum_2[1] = sum_1[1];
    assign sum_2[2] = sum_1[2];
    assign sum_2[3] = sum_1[3];
    assign sum_2[4] = sum_1[4];
    assign sum_2[5] = sum_1[5];
    assign sum_2[6] = sum_1[6];
    assign sum_2[7] = sum_1[7];

    // Combinational logic for final sum and carry
    assign sum_3[0] = sum_2[0];
    assign sum_3[1] = sum_2[1];
    assign sum_3[2] = sum_2[2];
    assign sum_3[3] = sum_2[3];
    assign sum_3[4] = sum_2[4];
    assign sum_3[5] = sum_2[5];
    assign sum_3[6] = sum_2[6];
    assign sum_3[7] = sum_2[7];

    // Assign outputs
    assign sum = sum_3;
    assign Co = Co2[1];
endmodule

module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire sum,
    output wire Co
);
    // Combinational logic for full adder
    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule