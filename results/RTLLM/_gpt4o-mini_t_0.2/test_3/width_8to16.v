module width_8to16(
	input                   clk         ,   
	input                   rst_n       ,
	input                   valid_in    ,
	input       [7:0]      data_in     ,
 
 	output  reg            valid_out    ,
	output  reg [15:0]     data_out
);

	reg [7:0] data_lock; // Register to hold the first 8-bit data input
	reg data_ready;       // Flag to indicate if we have first data ready

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_out     <= 16'b0;     // Clear output on reset
			valid_out    <= 1'b0;      // Clear valid signal on reset
			data_lock    <= 8'b0;       // Clear the data lock
			data_ready   <= 1'b0;      // Clear data ready flag
		end else begin
			if (valid_in) begin
				if (!data_ready) begin
					data_lock    <= data_in; // Store first valid data
					data_ready   <= 1'b1;    // Set data ready flag
				end else begin
					// Concatenate and generate output
					data_out     <= {data_lock, data_in}; // Concatenate data_lock and data_in
					valid_out    <= 1'b1; // Set output valid flag
					data_ready   <= 1'b0; // Reset data ready flag for next inputs
				end
			end else begin
				// If no valid data, do not produce output right away
				if (data_ready) begin
					valid_out    <= 1'b0; // Reset valid_out until new valid input arrives
				end
			end
		end
	end

endmodule