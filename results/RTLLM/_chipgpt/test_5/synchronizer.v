module synchronizer (
	input clka,clkb ,
	input arstn,brstn , //active-low reset
	input [3:0] din ,//data input
	input dataen , //enable input

	output reg[3:0] dout //output data
);

usecase_register m0(clka,arstn,dout,din,dataen,4'b0);
usecase_register m1(clkb,arstb,dout, din,dataen,4'b0);

always @(posedge clka or posedge brstn) begin
if(!arstn) dout<=4'b0;
else if(brstn) dout<=4'b0;
else if(dataen && ~{dataen}) dout<= din;
end
endmodule