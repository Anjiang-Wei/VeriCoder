module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0] dout_parallel,
	output reg dout_valid
);
	
	// Internal 4-bit counter to count the number of received bits
	reg [3:0] cnt;
	
	// Internal register to hold the serial data
	reg [7:0] shift_reg;
	
	// Internal signal to track if we are in the process of receiving data
	reg receiving_data;
	
	// On the rising edge of the clock
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset all internal signals
			cnt <= 4'b0;
			shift_reg <= 8'b0;
			dout_parallel <= 8'b0;
			dout_valid <= 1'b0;
			receiving_data <= 1'b0;
		end else begin
			// If reset is not active, check the validity of the input data
			if (din_valid) begin
				// If we are not currently receiving data
				if (!receiving_data) begin
					// Start receiving data
					receiving_data <= 1'b1;
					// Reset the counter
					cnt <= 4'b0;
				end
				
				// Increment the counter
				cnt <= cnt + 1;
				
				// Shift the serial data into the shift register
				if (cnt < 8) begin
					shift_reg <= {shift_reg[6:0], din_serial};
				end
				
				// If we have received 8 bits
				if (cnt == 7) begin
					// Output the data
					dout_parallel <= shift_reg;
					// Set the valid signal
					dout_valid <= 1'b1;
				end
				
				// If we have completed the transfer
				if (cnt == 7) begin
					// Reset the counter and receiving_data flag
					cnt <= 4'b0;
					receiving_data <= 1'b0;
				end
			end else begin
				// If no valid input data, reset the valid output signal
				dout_valid <= 1'b0;
			end
		end
	end
	
endmodule