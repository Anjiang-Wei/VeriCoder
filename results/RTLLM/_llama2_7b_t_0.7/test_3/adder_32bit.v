module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     // Instantiate 16-bit CLA blocks for each bit position
     assign S = {31'b0, adder_16bit(A[31],B[31])};
     assign C32 = adder_16bit(A[31],B[31]);

     // Implement carry propagation for each bit position
     always @* begin
       case (A[i])
        0: S[i] = B[i];
        1: if (B[i]) S[i] = 0; else S[i] = A[i];
        default: S[i] = 0;
       endcase
     end

     // Implement carry add for each bit position
     always @* begin
       case (A[i])
        0: C32 = 0;
        1: if (B[i]) C32 = 1; else C32 = ~C32;
        default: C32 = 0;
       endcase
     end