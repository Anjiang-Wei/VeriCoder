module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);

reg [7:0] data_lock;
wire flag;

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		data_lock <= 'b0;
	else if (valid_in && !flag)
		data_lock <= data_in;
end

assign flag = valid_in & data_lock[7];

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n || !flag)
		valid_out <= 1'b0;
	else
		valid_out <= 1'b1;
end

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		data_out <= 'b0;
	else if (valid_in && flag)
		data_out <= {data_lock, data_in};
end

endmodule