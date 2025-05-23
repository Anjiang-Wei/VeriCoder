module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output   reg			valid_out,
	output   reg [15:0]	data_out
);
	// Internal signals
	reg [7:0] data_lock;  // To store the first valid 8-bit data
	reg flag;             // To indicate if the first valid data is stored

	// On reset, clear the data_lock and flag
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_lock <= 8'b0;
			flag <= 1'b0;
			valid_out <= 1'b0;
			data_out <= 16'b0;
		end else begin
			// If valid_in is high and flag is low, store the data_in in data_lock and set flag
			if (valid_in && !flag) begin
				data_lock <= data_in;
				flag <= 1'b1;
			end
			// If valid_in is high and flag is high, concatenate data_lock and data_in to form data_out
			else if (valid_in && flag) begin
				data_out <= {data_lock, data_in};
				valid_out <= 1'b1;
				flag <= 1'b0;  // Reset the flag after generating the output
			end
			// If valid_in is low, reset valid_out and data_out
			else if (!valid_in) begin
				valid_out <= 1'b0;
			end
		end
	end

endmodule