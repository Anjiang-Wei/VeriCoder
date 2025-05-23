module adder_32bit(A,B,S,C32);
     input [31:0] A; // Corrected input port declaration
     input [31:0] B;
     output reg [31:0] S; // Added 'reg' keyword for output ports
     output wire C32;

// Calculate carries and sum bits using 4 CLA blocks (16-bit each)
CLA cla1(.A({A[15], A[14]}), .B({B[15], B[14]}), .C({c1, c0}), .S({s3, s2}));
CLA cla2(.A({A[13], A[12]}), .B({B[13], B[12]}), .C({c2, c1}), .S({s6, s5}));
CLA cla3(.A({A[11], A[10]}), .B({B[11], B[10]}), .C({c4, c3}), .S({s9, s8}));
CLA cla4(.A({A[9],  A[8]}), .B({B[9],  B[8]}), .C({c8, c7}), .S({s15, s14}));

// Generate the output sum using the generated sum bits
assign S[15:0] = {s15, s14, s13, s12, s11, s10, s9,  s8};

// Output the least significant bit of the carry-out (C32)
CLA cla5(.A({1'b0, A[7]}), .B({1'b0, B[7]}), .C({c12, c11}), .S({s18, s17}));
CLA cla6(.A({1'b0, A[6]}), .B({1'b0, B[6]}), .C({c16, c15}), .S({s19, s18}));

// Output the most significant bit of the carry-out (C32)
assign S[31:16] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, c8};

assign C32 = c12; // Output the final carry bit

endmodule

// CLA block implementation
module CLA(A,B,C,S);
     input [1:0] A;
     input [1:0] B;
     output wire [1:0] C;
     output wire [1:0] S;

     assign S[1] = (A[1]^B[1]) & (A[0]^B[0]);
     assign S[0] = (A[1]^B[1]) | (A[0]^B[0]);

     assign C[1] = A[1]^B[1];
endmodule