wire [15:0] P[31:0];
    wire [15:0] G[31:0];
    wire [15:0] C[32:0];
    wire [15:0] Cout;
    
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : gen
            cla_16bit cla(.A(A[15:0]), .B(B[15:0]), .P(P[i]), .G(G[i]), .C(C[i]), .Cout(Cout));
            assign S[i+16] = P[i][15] ^ G[i][15];
            assign S[i] = P[i][14] ^ G[i][14];
            assign C[i+1] = (P[i][15] & G[i][15]) | (P[i][14] & G[i][14]);
        end
    endgenerate
    
    assign C32 = C[32][1];
    
endmodule

module cla_16bit(A,B,P,G,C,Cout);
     input [15:0] A;
     input [15:0] B;
     output [15:0] P;
     output [15:0] G;
     output [15:0] C;
     output Cout;
    
    wire [15:0] p;
    wire [15:0] g;
    wire [15:0] c;
    
    assign p = A ^ B;
    assign g = A & B;
    assign c[0] = g[15];
    assign c[1] = g[14] | (p[15] & g[14]);
    assign c[2] = g[13] | (p[15] & g[13] & p[14]) | (p[14] & g[13]);
    assign c[3] = g[12] | (p[15] & g[12] & p[14] & p[13]) | (p[14] & g[12] & p[13]) | (p[13] & g[12]);
    assign c[4] = g[11] | (p[15] & g[11] & p[14] & p[13] & p[12]) | (p[14] & g[11] & p[13] & p[12]) | (p[13] & g[11] & p[12]);
    assign c[5] = g[10] | (p[15] & g[10] & p[14] & p[13] & p[12] & p[11]) | (p[14] & g[10] & p[13] & p[12] & p[11]) | (p[13] & g[10] & p[12] & p[11]);
    assign c[6] = g[9] | (p[15] & g[9] & p[14] & p[13] & p[12] & p[11] & p[10]) | (p[14] & g[9] & p[13] & p[12] & p[11] & p[10]) | (p[13] & g[9] & p[12] & p[11] & p[10]);
    assign c[7] = g[8] | (p[15] & g[8] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9]) | (p[14] & g[8] & p[13] & p[12] & p[11] & p[10] & p[9]) | (p[13] & g[8] & p[12] & p[11] & p[10] & p[9]);
    assign c[8] = g