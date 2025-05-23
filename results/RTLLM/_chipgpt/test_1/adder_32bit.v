module adder_32bit(A,B,S,C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;
    
	//CARRY LOOKAHEAD ADDER(CLA) ARCHITECTURE
	//16-bit adder is implemented by 4 CLA blocks, each block consists of four muxes
	 wire [7:0] S1; //output from first mux in the fourth CLA block (SUM[31:8])
	 wire [7:0] S2; //output from second mux in the third CLA block (SUM[23:16])
	 wire [7:0] S3; //output from third mux in the second CLA block (SUM[15:8])
	 wire [7:0] S4; //output from fourth mux in the first CLA block (SUM[7:0])
	 
	wire C_mux, B_mux, A_B_mux;//output from four muxes
	 
	//CARRY LOOKAHEAD ADDER(CLA) NORMAL FUNCTIONAL MODE
	//This circuit is designed to perform the normal function of a carry-lookahead adder
	always @(*) begin
	S[31:8] = S1; //SUM[31:8]=S0 + A + B (SUM should be "saturated" since the maximum value possible for the sum is 255)
	C32 = C_mux; //should be saturated as well, so 255 should be expected at the output of this mux
	S[23:16] = S2; //SUM[23:16]=S0 + A + B (SUM should be "saturated" since the maximum value possible for the sum is 255)
	C_mux = {B,A};
	S[15:8] = S3; //SUM[15:8]=S0 + A + B (SUM should be "saturated" since the maximum value possible for the sum is 255)
	B_mux = {C,A};
	S[7:0] = S4; //SUM[7:0]=S0 + A + B
	end
	 
	//CARRY LOOKAHEAD ADDER(CLA) BOUNDED FUNCTIONAL MODE
	//The circuit is designed to perform the bounded function of a carry-lookahead adder.
	always @(*) begin
	S[31:8] = S0; //SUM[31:8]=S0 + A + B (SUM should be "saturated" since the maximum value possible for the sum is 255)
	C32 = C_mux; //should be saturated as well, so 255 should be expected at the output of this mux
	S[23:16] = S0; //SUM[23:16]=S0 + A + B (SUM should be "saturated" since the maximum value possible for the sum is 255)
	C_mux = {B,A};
	S[15:8] = S0; //SUM[15:8]=S0 + A + B (SUM should be "saturated" since the maximum value possible for the sum is 255)
	B_mux = {C,A};
	S[7:0] = S0; //SUM[7:0]=S0 + A + B
	end
	assign C32 = C_mux&{A,B} | {1'b1,A} & B_mux ;//C=output of the fourth mux(should be saturated)
	assign S[7:0] = S4; //output from first CLA block
	assign S[8:9]= A&{C32}; //C is used as a carry-out, so the output from this mux should "saturate" since C_mux should be {1'b1,A} which implies that C32 will have a value of 1 (since S0 is being added to A and B)
	assign S[15:8] = S3; //output from second CLA block
	assign S[16:17]= B&{C32}; //B is used as a carry-in, so the output from this mux should "saturate" since B_mux should be {C,A} which implies that B32 will have a value of 1 (since S0 is being added to A and B)
	assign S[23:16]= S2; //output from third CLA block
	assign S[24:25]= A&{C32}; //A is used as an input, so the output from this mux should have a value of 0 (since S0 is being added to A and B)
	assign S[31:8] = S1; //output from fourth CLA block
	
endmodule