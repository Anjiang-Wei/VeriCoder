module width_8to16(
	input 				clk 		,   
	input 				rst_n		,
	input	valid_in	,
	input	[7:0]	data_in	,
  
 	output valid_out,
	output [15:0] data_out 
);
	 
    reg [15:0] data_lock; //8-bit data to be used for next data input
    reg [15:0] data_in1;   //8-bit data for next data input
    
    always @(posedge clk or negedge rst_n) begin : register_use
	if(!rst_n) 
	data_lock <= 'd0;
	else if(valid_in && !data_out[15])  //wait for the first data to be loaded into data_out and then use it as input for next data input.
		data_lock <= data_in;
	else 
		data_lock <= data_in1;
    end
    
    always @(posedge clk or negedge rst_n) begin : register_use2
	if(!rst_n)
	data_in1 <= 'd0;
	else if(valid_in && !data_out[15])  //wait for the first data to be loaded into data_out and then use it as input for next data input.
		data_in1 <= data_lock;
	else
		data	data_in1 <= data_in;
    end
    
  
    assign valid_out = (valid_in && !data_out[15]); //wait for the first data to be loaded into data_out and then use it as input for next data input.
    assign data_out = {data_lock, data_in1};  //concat two data inputs as one 16-bit output. The valid data is temporarily stored in "data_lock". When the second valid data arrives, they are concatenated to produce the output signal and register

endmodule