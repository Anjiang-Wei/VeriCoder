module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output	reg			valid_out,
	output   reg [15:0]	data_out
);

	// Register to hold the first 8-bit data input
	reg [7:0] data_lock;

	// Flag to indicate when the first valid data is received
	reg flag;

	// Trigger the combinational logic on clock edge or reset
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_lock <= 8'b0;  // Clear data_lock register on reset
			valid_out <= 1'b0;  // Clear valid_out signal on reset
			flag <= 1'b0;       // Clear flag on reset
			data_out <= 16'b0;  // Clear data_out register on reset
		end else if (valid_in) begin
			if (flag) begin
				// If flag is set, concatenate data_lock and data_in
				data_out <= {data_lock, data_in}; // Concatenate the data
				valid_out <= 1'b1; // Set valid_out to indicate valid output
				flag <= 1'b0;     // Reset flag after processing
			end else begin
				// Store the first valid data in data_lock
				data_lock <= data_in; // Store the first 8-bit data
				flag <= 1'b1;        // Set flag to indicate first data received
			end
		end
	end

endmodule