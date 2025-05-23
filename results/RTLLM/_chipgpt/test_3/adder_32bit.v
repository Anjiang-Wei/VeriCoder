module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32);


    wire[15:0] sum;
    wire C0,C1,C2,C3;

  // CLA Block with 4 bits
    CLA m0 (A[0],B[0],S[0],C0);
    CLA m1 (A[1],B[1],S[1],C1);
    CLA m2 (A[2],B[2],S[2],C2);
    CLA m3 (A[3],B[3],S[3],C3);
    
    // Sums the first 4 bits to make it a 16 bit adder
    assign sum[15:0] = {sum[14:0],C0,C1,C2,C3};
      

    // output C3 and C32 for next module
    assign S[31:16]=sum[15:0];
    assign C32=C3;
endmodule