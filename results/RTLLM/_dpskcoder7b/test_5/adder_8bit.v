wire [6:0] c;

    // Full Adder
    // This is the first full adder in the series.
    // It takes inputs a[0], b[0] and cin, and outputs sum[0] and c[0]
    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);

    // The remaining full adders in the series.
    // The carry-in input of each full adder is the carry-out of the previous one.
    genvar i;
    generate
        for(i=1; i<8; i=i+1)
        begin : adder
            full_adder fa(a[i], b[i], c[i-1], sum[i], c[i]);
        end
    endgenerate

    // The final carry-out is the carry-out of the last full adder.
    assign cout = c[7];
endmodule

// Full Adder module
module full_adder(
    input a, b, cin, 
    output sum, cout);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule