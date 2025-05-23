module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

// Instantiate an 8-bit adder module multiple times to implement the full adder
module adder (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

// Implementation of the 8-bit adder
y = a + b + Cin;
Co = a + b - Cin;
endmodule

// Instantiate the 8-bit adder module multiple times to implement the full adder
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
) {
    adder ADderA[8]; // Instantiate the 8-bit adder module 8 times
    adder ADderB[8]; // Instantiate the 8-bit adder module 8 times
    
    // Connect the inputs of the 8-bit adders to the corresponding bits of the input signals
    ADderA[0].input.a = a[7:0];
    ADderA[0].input.b = b[7:0];
    ADderA[0].input.Cin = Cin[7:0];
    
    ADderB[0].input.a = a[15:8];
    ADderB[0].input.b = b[15:8];
    ADderB[0].input.Cin = Cin[15:8];
    
    // Connect the outputs of the 8-bit adders to the output signals
    ADderA[0].output.y = y[7:0];
    ADderB[0].output.y = y[15:8];
    
    ADderA[0].output.Co = Co[7:0];
    ADderB[0].output.Co = Co[15:8];
}
endmodule