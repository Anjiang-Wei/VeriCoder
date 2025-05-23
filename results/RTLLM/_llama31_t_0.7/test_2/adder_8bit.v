module adder_8bit(
    input [7:0] a, b, // Input operands A and B (8 bits each)
    input cin,        // Carry-in input (1 bit)
    output [7:0] sum, // Output representing the sum of A and B (8 bits)
    output cout       // Carry-out output (1 bit)
);

// Bit-level adder for each bit position
wire [7:0] carry;

assign {carry[7], carry[6], carry[5], carry[4], 
        carry[3], carry[2], carry[1], carry[0]} = {a[7], a[6], a[5], a[4],
                                                    a[3],  a[2],  a[1],  a[0]};

// Full adder for each bit position
wire [7:0] partial_sum;

assign {partial_sum[7], partial_sum[6], partial_sum[5], partial_sum[4],
        partial_sum[3], partial_sum[2], partial_sum[1], partial_sum[0]} = 
{carry[7]^b[7], carry[6]^b[6], carry[5]^b[5], carry[4]^b[4],
 carry[3]^b[3],  carry[2]^b[2],  carry[1]^b[1],  carry[0]^b[0]};

// Combine partial sums
assign sum = partial_sum;

// Calculate the final carry-out output
assign cout = carry[7];

endmodule