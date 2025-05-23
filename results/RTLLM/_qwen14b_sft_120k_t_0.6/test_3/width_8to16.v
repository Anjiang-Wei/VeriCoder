module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output	reg			valid_out,
	output   reg [15:0]	data_out
);

	// Register to lock the first 8-bit data input
	reg [7:0] data_lock;
	// Flag to indicate when the first data is locked
	reg flag;

	// Always block for data locking and output generation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_lock <= 8'b0;
			flag <= 1'b0;
			valid_out <= 1'b0;
			data_out <= 16'b0;
		end else if (valid_in) begin
			if (flag) begin
				// Generate output when the second data input arrives
				valid_out <= 1'b1;
				data_out <= {data_lock, data_in};
			end else begin
				// Lock the first data input
				data_lock <= data_in;
				flag <= 1'b1;
			end
		end
	end

endmodule