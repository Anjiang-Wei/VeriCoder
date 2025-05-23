module mult_booth_8bit (
	input clk, 
	input reset, 
	input [7:0] a,b,
	output reg[15:0] p,
	output reg rdy  
    );
	 //counter register for Booth's multiplier
	 localparam N = 4;
	 wire[N-1:0] ctr;
	 genvar i;
	 generate
		for (i=0; i<N; i = i+1) begin : mult_gen
		 reg[5:0] multiplier ;
		 wire pos; 
		 reg[7:0] multiplicand;
		 wire[15:0] p_tmp;
		 
		 //register for Booth's multiplier
		 assign {multiplier[N-1], multiplier[N-2], ... , multiplier[0]} = a[i*8+7:i*8+8];
		 assign pos = (a[i*8+8] == 1)? 1 : 0; //if (a[i*8+8]) is 1, then it's positive Booth encoding. If not , then it's negative Booth encoding.
		 
		 //register for multiplicand
		 assign {multiplicand[N-1:0]} = b[i*8+7:i*8+8];   //{b[i*8+7:i*8+8]} is the multiplier.
		 
		 //use the Booth's multiplier and multiplicand to get the product
		 always @(posedge clk, pos) begin
		 if (reset) p <= 0; //if the reset is high, then the starting state is zero  
		 else begin
			 if(pos && !multiplicand[7]) p_tmp = multiplier;    //if pos and multiplicand[7] are both true at same time, it means that multiplying 1 by an array of 8 will result in a number. Therefore it should be stored as the value of multiplier
			 else if(~pos && multiplicand[7]) p_tmp = {p_tmp[0], multiplicand}; //if pos and multiplicand[7] are both false at same time, it means that multiplying 1 by an array of 8 will result in a number. Therefore it should be stored as the value of multiplicand
			 else if(~pos && ~multiplicand[7]) p_tmp = {p_tmp[0], 8'hFF}; //if pos and multicicander[7] are both false at same time, it means that multiplying 1 by an array of 8 will result in a number. Therefore it should be stored as the value of 8'hFF
		 end
		 p <= {p_tmp[0], p_tmp[1:7]}; //add one more bit to the end so that it can represent the whole number of the array.
		 end
	 end
endmodule