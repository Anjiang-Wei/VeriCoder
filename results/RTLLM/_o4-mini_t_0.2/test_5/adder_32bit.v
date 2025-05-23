// 16‑bit Carry‑Lookahead Adder
module cla16(
    input  [16:1] A,
    input  [16:1] B,
    input         cin,
    output [16:1] S,
    output        P,    // block propagate
    output        G     // block generate
);
    wire [16:1] p, g;
    wire [16:0] c;
    wire [16:1] gp;      // intermediate group–generate

    // bitwise propagate and generate
    genvar i;
    generate
      for(i=1; i<=16; i=i+1) begin : pg
        assign p[i] = A[i] ^ B[i];
        assign g[i] = A[i] & B[i];
      end
    endgenerate

    // carry chain: c[0]=cin, c[i]=g[i] | (p[i]&c[i-1])
    assign c[0] = cin;
    generate
      for(i=1; i<=16; i=i+1) begin : carry
        assign c[i] = g[i] | (p[i] & c[i-1]);
      end
    endgenerate

    // sum bits
    generate
      for(i=1; i<=16; i=i+1) begin : sum
        assign S[i] = p[i] ^ c[i-1];
      end
    endgenerate

    // block propagate: all p[i] must be 1
    assign P = &p;       // reduction AND over p[1:16]

    // block generate: gp[i] = generate for bits 1..i with cin=0
    generate
      for(i=1; i<=16; i=i+1) begin : gp_calc
        if(i==1)
          assign gp[i] = g[i];
        else
          assign gp[i] = g[i] | (p[i] & gp[i-1]);
      end
    endgenerate
    assign G = gp[16];

endmodule


// Top‑level 32‑bit adder built from two 16‑bit CLA blocks
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire        P1, G1;
    wire        P2, G2;
    wire        C16;

    // lower 16 bits, cin = 0
    cla16 cla_lo (
      .A   (A[16:1]),
      .B   (B[16:1]),
      .cin (1'b0),
      .S   (S[16:1]),
      .P   (P1),
      .G   (G1)
    );

    // carry into upper half
    assign C16 = G1;      // since cin_lo=0, C17 = G1 | (P1&0) = G1

    // upper 16 bits
    cla16 cla_hi (
      .A   (A[32:17]),
      .B   (B[32:17]),
      .cin (C16),
      .S   (S[32:17]),
      .P   (P2),
      .G   (G2)
    );

    // final carry out
    assign C32 = G2 | (P2 & C16);

endmodule