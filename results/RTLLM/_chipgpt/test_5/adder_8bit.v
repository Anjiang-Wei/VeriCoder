module adder_8bit (
    input [7:0] a,
    input cin,
    output [7:0] sum,
    output cout
);

wire [7:1] m0;
wire [7:1] m1;
assign {m0[6], m0[5]} = a[7:4];
assign {m1[6], m1[5]} = a[3:0];
assign sum[7] = m0[6] || m1[6]; //sum of 8-bit number(A) and cout(B) will be on the last bit of output(sum)
assign {sum[4:0], cout} = (m0[5] && !cin) | (!m0[5] && m1[5]); //cout is the carry out bit
assign sum[7:3] = m0[5] ? m0[4:0] : m1[3:0]; //sum of 8-bit number(A) and 3-bit number(B) will be at {sum[7:3]} of output.
assign sum[2:0] = m1[2:0]; //sum of 5-bit number (A) and 3-bit number (B) will be at {sum[2:0]} of output.

endmodule