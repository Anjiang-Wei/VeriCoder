module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    wire [6:0] carry;
    assign carry[0] = cin;
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin: full_adder
            full_adder fa(a[i], b[i], carry[i], sum[i], carry[i+1]);
        end
    endgenerate
    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    assign cout = carry[7];

endmodule

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule