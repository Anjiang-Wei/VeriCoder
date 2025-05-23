module adder_16bit(A, B, P, G, CO);
    input [15:0] A;
    input [15:0] B;
    output [15:0] P; // Partial sum
    output [15:0] G; // Generate signals
    output CO;        // Carry-out

    reg [15:0] g0, g1, p0, p1;

    assign {g0, g1} = A[15]^B[15]?{A[14], B[14]}:{(A[14]&B[14]), (A[14]|B[14])};
    assign {p0, p1} = (A[15] & B[15]) ? {A[15], B[15]} : {(A[15] ^ B[15]), (A[15] ^ B[15])};

endmodule

// 32-bit CLA adder
module adder_32bit(A, B, S, C32);
    input [31:0] A;
    input [31:0] B;
    output [31:0] S;
    output C32;

    wire [15:0] P0, G0, P1, G1, CO0, P2, G2, P3, G3, P4, G4, P5, G5, P6, G6, P7, G7;
    wire [31:0] sum;

    assign S = {P7,P6,P5,P4,P3,P2,P1,P0};

    // Instantiate 16-bit CLA blocks
    adder_16bit clainst0 (.A(A[15:0]), .B(B[15:0]), .P(P7), .G(G7), .CO(CO0));
    assign {P6, G6} = CO0 ^ G7;
    assign {p5, g5} = (G7 & !CO0)? {A[31], B[31]} : {(A[31] ^ B[31]), (A[31] ^ B[31])};

    adder_16bit clainst1 (.A(A[31:16]), .B(B[31:16]), .P(P5), .G(G5), .CO(CO1));
    assign {P4, G4} = CO0 & (A[15] | B[15]);
    assign {p3, g3} = (G7 & A[15])? {A[31],B[31]} : {(A[31]^B[31]),(A[31]^B[31])};

    adder_16bit clainst2 (.A(A[47:32]), .B(B[47:32]), .P(P3), .G(G3), .CO(CO2));
    assign {p2, g2} = (G7 & A[15] & B[15])? {A[31],B[31]} : {(A[31]^B[31]),(A[31]^B[31])};

    adder_16bit clainst3 (.A(A[63:48]), .B(B[63:48]), .P(P2), .G(G2), .CO(CO3));
    assign {p1, g1} = (CO0 & !(A[15]^B[15])) ? {A[31], B[31]} : {(A[31] ^ B[31]), (A[31] ^ B[31])};

    adder_16bit clainst4 (.A(A[95:80]), .B(B[95:80]), .P(P1), .G(G1), .CO(CO4));
    assign {p0, g0} = (CO0 & A[15] ^ B[15])? {A[31], B[31]} : {(A[31]^B[31]),(A[31]^B[31])};

    adder_16bit clainst5 (.A(A[127:112]), .B(B[127:112]), .P(P0), .G(G0), .CO(CO5));
    assign C32 = CO4 | (CO3 & !CO2) | !(CO1 & CO0);

endmodule