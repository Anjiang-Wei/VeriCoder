module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire [14:0] carry;

    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(Cin), .sum(y[0]), .cout(carry[0]));

    genvar i;
    generate
        for (i=1; i<=14; i=i+1) begin : fa_gen
            full_adder fa (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(y[i]), .cout(carry[i]));
        end
    endgenerate

    assign y[15] = a[15] ^ b[15] ^ carry[14];
    assign Co = carry[14];
endmodule