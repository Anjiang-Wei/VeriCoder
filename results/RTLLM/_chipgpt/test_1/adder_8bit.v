module adder_8bit (
	input [7:0] a, b, 
	input cin, 
	output [7:0] sum, 
	output cout 
    );
	 
	 
	 //Bit-level full adders for 8-bit addition.
	 assign sum[7] = (a[7]&~b[7]) | (a[7]&b[7] & cin); 
	 assign sum[6] = a[6]&b[6] | (a[6]&cin | b[6]&cout);
	 assign sum[5:0] = {sum[5], sum[4:0]} ;
	 
	 //cout=1 if all bits of result are 1, else cout is 0.
	 always @(a,b,cout) begin
			cout = ~cout;  
	 end 
	 
endmodule