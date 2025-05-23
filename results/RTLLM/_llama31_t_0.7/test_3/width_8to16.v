module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
	output	reg			valid_out,
	output   reg [15:0]	data_out
);

reg  [7:0] data_lock; // Temporary register to store the first valid input data
reg        flag;       // Flag signal indicating that two valid inputs have been received

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		data_out <= '0;
		flag      <= 1'b0;
	end else if (valid_in && !flag) begin
		data_lock <= data_in; // Store the first valid input in data_lock register
		flag       <= 1'b1;
	end else if (valid_in && flag) begin
		data_out <= {data_lock, data_in}; // Concatenate the contents of data_lock and data_in to form a 16-bit output
		valid_out <= 1'b1; // Set valid_out signal to indicate that the output is valid
	end else begin
		flag       <= 1'b0;
		valid_out <= 1'b0;
	end
end

endmodule