module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0] dout_parallel,
	output reg dout_valid
);

	// Counter to track number of bits received
	reg [2:0] cnt; // 3-bit counter is sufficient for counting up to 7 (0 to 7)

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset all registers on active-low reset
			dout_parallel <= 8'b0;
			dout_valid <= 1'b0;
			cnt <= 3'd0;
		end else begin
			if (din_valid) begin
				// Shift `din_serial` into `dout_parallel` (MSB first)
				dout_parallel <= {dout_parallel[6:0], din_serial};
				cnt <= cnt + 1;

				if (cnt == 3'd7) begin
					// All 8 bits received, set `dout_valid` to 1
					dout_valid <= 1'b1;
					cnt <= 3'd0; // Reset counter to 0 for the next 8 bits
				end else begin
					// Not enough bits yet, `dout_valid` remains 0
					dout_valid <= 1'b0;
				end
			end else begin
				// If din_valid is not set, output remains invalid
				dout_valid <= 1'b0;
			end
		end
	end

endmodule