module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);
	// 4-bit counter to track the number of bits received
	reg [3:0] cnt;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			dout_parallel <= 8'b0;
			dout_valid <= 1'b0;
			cnt <= 4'b0;
		end else begin
			if (din_valid) begin
				if (cnt < 7) begin
					// Shift the parallel output left by 1 bit and insert the new serial bit
					dout_parallel <= {dout_parallel[6:0], din_serial};
					cnt <= cnt + 1'b1;
				end else begin
					// Insert the last serial bit to complete the 8-bit word
					dout_parallel <= {dout_parallel[6:0], din_serial};
					dout_valid <= 1'b1;
					cnt <= 4'b0;
				end
			end else begin
				// Reset the counter if the input is not valid
				cnt <= 4'b0;
				dout_valid <= 1'b0;
			end
		end
	end

endmodule