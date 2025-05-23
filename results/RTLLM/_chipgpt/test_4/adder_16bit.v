module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

wire [15:0] sum;
assign sum[15] = a[15] ^ (y[15] & ~Cin) | (~a[15] & y[15]); // 1's complement of carry bit
assign sum[14:0] = a[14:0] + b[14:0] + Cin;
assign Co = (y[15] == 1) | ((~a[15]) & y[15]); // carry output is logic "1" when the last bit of A and B are both logic "1", or when the last bit of A is a logic "1" and the sum of A and B is logic "0".
assign y = {sum, Co};

endmodule