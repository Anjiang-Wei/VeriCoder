module width_8to16(
    input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,

	output	reg			valid_out,
	output   reg [15:0]	data_out
);

reg [7:0]	data_lock;			// Temporary storage for the first input data

always @ (posedge clk or negedge rst_n) begin
	if (!rst_n)
		begin
			data_out <= 16'h0000;
			valid_out <= 1'b0;
		end
	else if (valid_in) begin
		if (data_lock == 8'h00 && data_in != 8'h00) begin // Wait for the second valid data input
			data_lock <= data_in;
			valid_out <= 1'b1;
		end else if (!valid_out) begin // Update data_out with concatenated values when the first valid data is inputted or on reset
			if (!rst_n)
				data_out <= {data_lock, 8'h0};
			else
				data_out <= {data_lock, data_in};
		end
	end
end

endmodule