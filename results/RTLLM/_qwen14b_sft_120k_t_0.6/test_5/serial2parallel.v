module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0] dout_parallel,
	output reg dout_valid
);
	
	// 4-bit counter to track the number of serial input bits received
	reg [3:0] cnt;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 4'd0;  // Reset the counter to 0
			dout_parallel <= 8'b0;  // Reset the parallel output to 0
			dout_valid <= 1'b0;  // Set the valid signal to 0
		end else if (din_valid) begin
			if (cnt < 4'd7) begin
				// Shift the current parallel data left by 1 bit and insert the new serial bit
				dout_parallel <= {dout_parallel[6:0], din_serial};
				cnt <= cnt + 1'b1;  // Increment the counter
			end else begin
				// Insert the last serial bit and reset the counter
				dout_parallel <= {dout_parallel[6:0], din_serial};
				dout_valid <= 1'b1;  // Set the valid signal to 1
				cnt <= 4'd0;  // Reset the counter
			end
		end else begin
			dout_valid <= 1'b0;  // Reset the valid signal when input is not valid
		end
	end
endmodule