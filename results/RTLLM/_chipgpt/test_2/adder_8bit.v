module adder(
	input [3:0] a, b, 
	input cin, 
	output [3:0] sum, 
	output cout);
	wire [3:0] s;
	assign sum = s[3:0];
	assign cout = (a==4'b1111 && b==4'b0000) ? 1'b1 : cin? 1'b0 : 1'b1;
	adder m0(a, b, sum, cout); // 7-bit adder
	adder m1(s[1:0], s[3:2], sum[1:0], cout); // 6-bit adder
	adder m2(s[2:1], s[5:4], sum[2:1], cout); // 5-bit adder
	adder m3(s[3:2], s[7:6], sum[3:2], cout); // 4-bit adder
	adder m4(s[4:3], s[9:8], sum[4:3], cout); // 3-bit adder
	adder m5(s[5:4], s[12:11], sum[5:4], cout); // 2-bit adder
	adder m6(s[6:5], s[15:13], sum[6:5], cout); // 1-bit adder
endmodule