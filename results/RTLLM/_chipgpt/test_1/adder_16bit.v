module adder_8bit (
	input wire [7:0] a,
	input wire [7:0] b,
	input wire Cin,
	output wire [7:0] y,
	output wire Co
    );
	 
	 reg [7:0] sum;
	 reg [1:0] n; // 1 for carry out, 2 for borrow out
	 assign y = {sum[6:0],n[1]?1:0};
	 
	 always @* begin
		n=0;
		sum=0;
		if(Cin) n=1; //add carry-in to the next operation
		//do addition of 2-bit numbers with carry out
		for (i=0; i<8; i=i+1) begin
			if(a[i]&&!b[i]) sum[i+1]=1; //add 1 to the next bit if a has one and b doesnt have any
			else if(!a[i]&&b[i]) sum[i+1]=1; //add 1 to the next bit if a didnt have one but b had one
			else sum[i+1]=0;
		}
		y[7:0]=sum;
	 end

endmodule