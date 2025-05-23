module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Define 8-bit adder instances
    wire [7:0] c1;
    wire c2;
    
    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder_8bit_1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c1[0])
    );
    
    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit adder_8bit_2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1[0]),
        .y(y[15:8]),
        .Co(c2)
    );
    
    // Assign the final carry-out
    assign Co = c2;
endmodule

// Define the 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    // Define internal wires for carry
    wire [7:0] carry;
    
    // Generate the sum and carry for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_adder
            assign y[i] = a[i] ^ b[i] ^ Cin;
            assign carry[i] = (a[i] & b[i]) | (a[i] & Cin) | (b[i] & Cin);
        end
    endgenerate
    
    // Assign the final carry-out
    assign Co = carry[7];
endmodule