module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout
);

    wire [8:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : fa
            full_adder fa_inst (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[8];

endmodule