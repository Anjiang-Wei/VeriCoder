module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] carry;

    // Instantiate 8-bit adders
    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin : adder_stage
            adder_8bit adder (
                .a(a[i*8+7:i*8]),
                .b(b[i*8+7:i*8]),
                .Cin(i == 0 ? Cin : carry[i-1]),
                .y(y[i*8+7:i*8]),
                .Co(carry[i])
            );
        end
    endgenerate

    assign Co = carry[1];

endmodule