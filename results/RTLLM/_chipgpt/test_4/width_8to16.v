module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);

reg [8:0] data_lock;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) 
        data_out_reg<=0;
    else if(valid_in && !data_lock[7])   //when valid input and first data has been received, then start to accumulate data
        data_out_reg<=data_out_reg<<1 | data_in; 
    else if(!rst_n&&(valid_in && data_lock[7]))
        data_out_reg<=data_out_reg>>1 | data_in;   //when valid input and second data has been received, then concat the first data with the second data to produce the output data
    else 
        data_out_reg<=0;
end

always @(posedge clk or negedge rst_n) begin   //concatenate data into 16 bits
    if(!rst_n)
        data_lock<=0;
    else if(valid_in && !data_lock[7])   //when valid input and first data has been received, then start to accumulate data
        data_lock<=data_lock<<1 | 1'b1; 
    else if(!rst_n&&(valid_in && data_lock[7]))
        data_lock<=data_lock>>1 | 1'b1;   //when valid input and second data has been received, then concat the first data with the second data to produce the output data
    else 
        data_lock<=0;
end

assign valid_out=valid_in && !data_lock[7];
assign data_out=(data_out_reg==16'hffff)?data_in:data_out_reg;  //if the data is valid, then output it, else keep using the previous data to make it a 16-bit number. 

endmodule