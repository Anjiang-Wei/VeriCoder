module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);
// register
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) data_out <= 'd0;
	else if(valid_in && valid_out)  //when the data is valid, the next bit of the data will be stored in the register. It will also be outputed as a valid bit.
	data_out <= {data_out[15:8], data_in};
end
// register for 4-bit locking
reg [3:0] data_lock;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) data_lock <= 'd0;
    else if(valid_in && valid_out) //when the data is valid, the next bit of the data will be stored in this register. It will also be outputed as a valid bit.
	data_lock <= {data_lock[3:0], data_in};
end
// register for 4-bit locking
reg [7:0] data_out_tmp; //will store the first eight bits of the input
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) data_out_tmp <= 'd0;
    else if(valid_in && valid_out)   //when the data is valid, the next bit of the data will be stored in this register. It will also be outputed as a valid bit.
	data_out_tmp <= {data_out_tmp[7:0], data_in}; 
end
//next-state flipflop
always @* begin  
    if(valid_in && !valid_out) //when the last bit of the data is valid, it will be outputted and stored in next-state flipflop.
	valid_out <= 1'b0;
    else if(!valid_in && valid_out) //when any other bit of the data is not valid, the state will be flipped to zero so that the next bit can be outputted and stored in the next-state flipflop.
	valid_out <= 1'b1;
end
//use next-state flipflop to generate a valid signal from a register for the data output.
assign data_out = {data_lock[3:0], data_out_tmp};

endmodule