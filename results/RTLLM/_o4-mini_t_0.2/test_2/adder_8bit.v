module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

  // Internal carry chain: carry[0] is the external cin,
  // carry[8] will become the external cout.
  wire [8:0] carry;
  assign carry[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : gen_full_adder
      // sum bit
      assign sum[i] = a[i] ^ b[i] ^ carry[i];
      // carry next
      assign carry[i+1] = (a[i] & b[i])
                        | (a[i] & carry[i])
                        | (b[i] & carry[i]);
    end
  endgenerate

  // Final carry out
  assign cout = carry[8];

endmodule