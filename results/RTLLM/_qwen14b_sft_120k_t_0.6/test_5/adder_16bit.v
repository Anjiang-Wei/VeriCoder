module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire [15:0] carry;
    wire Co1, Co2, Co3, Co4, Co5, Co6, Co7, Co8;

    // Instantiate 8-bit adders
    adder_8bit adder0(.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(Co1));
    adder_8bit adder1(.a(a[15:8]), .b(b[15:8]), .Cin(Co1), .y(y[15:8]), .Co(Co2));

    // Carry chain
    assign carry[0] = Cin;
    assign carry[1] = Co1;
    assign carry[2] = Co2;
    assign carry[3] = Co3;
    assign carry[4] = Co4;
    assign carry[5] = Co5;
    assign carry[6] = Co6;
    assign carry[7] = Co7;
    assign carry[8] = Co8;

    // Carry-out
    assign Co = carry[8];

    // Instantiate remaining 8-bit adders
    adder_8bit adder2(.a(8'b0), .b(8'b0), .Cin(carry[2]), .y(8'b0), .Co(Co3));
    adder_8bit adder3(.a(8'b0), .b(8'b0), .Cin(carry[3]), .y(8'b0), .Co(Co4));
    adder_8bit adder4(.a(8'b0), .b(8'b0), .Cin(carry[4]), .y(8'b0), .Co(Co5));
    adder_8bit adder5(.a(8'b0), .b(8'b0), .Cin(carry[5]), .y(8'b0), .Co(Co6));
    adder_8bit adder6(.a(8'b0), .b(8'b0), .Cin(carry[6]), .y(8'b0), .Co(Co7));
    adder_8bit adder7(.a(8'b0), .b(8'b0), .Cin(carry[7]), .y(8'b0), .Co(Co8));

endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    wire [7:0] sum;

    assign sum = a ^ b ^ {7'b0, Cin};  // Sum calculation
    assign Co = (a & b) | (Cin & (a ^ b));  // Carry calculation

    assign y = sum;
endmodule