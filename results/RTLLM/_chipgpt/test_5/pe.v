module multiplier_accumulator(
	input clk,rst,
	input [31:0] a,b,
	output[31:0] c 
    );
	 reg[31:0] c; //register for accumulation
	 always @(posedge clk or posedge rst) begin
	 if(rst) c <= 0;
	 else c <= c + a*b;
	 end
	 assign c[31:24]=c[31:24]+a*b;
	assign c[23:0] = c[23:0];
	assign c[31:24]={c[23:0],c[31:24]}; //sum of last 24 bits
	assign c[31] = c[30]+1'b1; //sign bit
	assign c[30]=c[30];
	assign c[29:1]=c[31:29];//28-bit value of c[31:24].
	assign c[0] = c[30] ? 1'b0 : 1'b1; //sign bit
	assign c[1] = {c[0],{c[29:1]}}+a*b-c;//next value of c after accumulation
	assign c[23:0]=c[31:24];//copy last 24 bits into next location of register for accumulation
	assign c[23:0]= {c[31:24],c[23:0]}; //copy last 24 bits of c as next value.
endmodule