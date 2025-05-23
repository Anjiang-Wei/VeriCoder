module adder_32bit(A,B,S,C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    // Instantiate multiple instances of the 16-bit CLA block
    always @(A or B) begin
        S <= 0; // Initialize sum to zero
        C32 <= 0; // Initialize carry to zero

        for (int i = 0; i < 16; i++) begin
            if (A[i] && !B[i]) begin // If A[i] is 1 and B[i] is 0, generate a carry
                C32 <= 1;
                S[i] <= A[i];
            end else if (!A[i] && B[i]) begin // If A[i] is 0 and B[i] is 1, generate a carry
                C32 <= 1;
                S[i] <= B[i];
            end else begin // Otherwise, do nothing
                S[i] <= 0;
                C32 <= 0;
            end
        end
    end
endmodule