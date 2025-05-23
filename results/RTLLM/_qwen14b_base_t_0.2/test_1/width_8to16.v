module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output   reg			valid_out,
	output   reg [15:0]	data_out
);
	// Internal registers
	reg [7:0] data_lock;
	reg flag;

	// On reset, clear the data_lock and flag
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_lock <= 8'b0;
			flag <= 1'b0;
		end else begin
			if (valid_in && !flag) begin
				// Store the first valid input data
				data_lock <= data_in;
				flag <= 1'b1;
			end else if (valid_in && flag) begin
				// Concatenate the stored data and the new data
				data_out <= {data_lock, data_in};
				valid_out <= 1'b1;
				// Reset the flag and data_lock for the next pair of inputs
				flag <= 1'b0;
				data_lock <= 8'b0;
			end
		end
	end

	// Clear valid_out after one clock cycle
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			valid_out <= 1'b0;
		end else begin
			if (valid_out) begin
				valid_out <= 1'b0;
			end
		end
	end
endmodule