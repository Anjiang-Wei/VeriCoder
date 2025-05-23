module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

// Bit-level adders for each bit of A and B
localparam [1:0] BITS = 8;
wire [BITS*2-1:0] adder_out0 = (a[0] + b[0]) & (~cin);
wire [BITS*2-1:0] adder_out1 = (a[1] + b[1]) & cin;
wire [BITS*2-1:0] adder_out2 = (a[2] + b[2]) & ~cin;
wire [BITS*2-1:0] adder_out3 = (a[3] + b[3]) & cin;
wire [BITS*2-1:0] adder_out4 = (a[4] + b[4]) & ~cin;
wire [BITS*2-1:0] adder_out5 = (a[5] + b[5]) & cin;
wire [BITS*2-1:0] adder_out6 = (a[6] + b[6]) & ~cin;
wire [BITS*2-1:0] adder_out7 = (a[7] + b[7]) & cin;

// Combine the outputs of the bit-level adders to get the overall sum
wire [7:0] sum = adder_out0 + adder_out1 + adder_out2 + adder_out3 + adder_out4 + adder_out5 + adder_out6 + adder_out7;

// Output the carry bit
wire cout = cin & (sum[7] != 0);

endmodule