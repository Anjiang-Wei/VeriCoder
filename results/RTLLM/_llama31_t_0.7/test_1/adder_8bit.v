module adder_8bit(
    input [7:0] a, b,
    input cin,
    output [7:0] sum,
    output cout);

// Declare the internal wires to store carry values
wire [7:0] carry;

assign {cout, carry[7]} = full_adder(a[7], b[7], cin);
generate
for (genvar i = 6; i >= 0; i--) begin : bit_adders
    assign carry[i] = full_adder(a[i], b[i], carry[i+1]);
end
endgenerate

assign sum[7:0] = {carry[0], a[7:0] + b[7:0]};
endmodule